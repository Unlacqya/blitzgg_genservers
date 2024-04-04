defmodule Blitzgg.Riot.LoL.Worker do
  alias Blitzgg.Riot.LoL.{Region, Match, Summoner, SummonerSupervisor}
  alias FE.Result

  def run do
    Map.new()
    |> fetch_summoner_name()
    |> fetch_platform()
    |> convert_to_region()
    |> Result.and_then(&get_summoner/1)
    |> Result.and_then(&get_match_ids/1)
    |> Result.and_then(&get_match_history/1)
    |> Result.and_then(&post_summoner_names/1)
    |> case do
      {:error, :invalid_platform} ->
        IO.write("Invalid region platform, please try again.")

      {:error, :summoner_not_found} ->
        IO.write("Summoner not found, please try again.")

      {:error, :forbidden} ->
        IO.write("Access to Riot API forbidden, do you have a valid API key?")

      args ->
        SummonerSupervisor.start_child(args)
    end

    :timer.sleep(3600000)
  end

  defp fetch_summoner_name(args) do
    summoner_name =
      "Please Enter a Summoner Name: "
      |> IO.gets()
      |> String.trim()

    Map.put(args, :summoner_name, summoner_name)
  end

  defp fetch_platform(args) do
    platform =
      "Please Enter a Region Platform (eg: NA1): "
      |> IO.gets()
      |> String.trim()
      |> String.upcase()

    Map.put(args, :platform, platform)
  end

  defp convert_to_region(%{platform: platform} = args) do
    platform
    |> Region.platform_to_region()
    |> Result.and_then(&add_to_args(args, :region, &1))
  end

  defp get_summoner(%{summoner_name: summoner_name, platform: platform} = args) do
    summoner_name
    |> Summoner.get_by_name(platform)
    |> Result.and_then(&add_to_args(args, :summoner, &1))
  end

  defp get_match_ids(%{summoner: summoner, region: region} = args) do
    summoner
    |> Summoner.get_match_ids(region)
    |> case do
      {:ok, %HTTPoison.Response{status_code: 403}} ->
        Result.error(:forbidden)

      {:ok, %HTTPoison.Response{status_code: 404}} ->
        Result.error(:match_ids_not_found)

      {:ok, %HTTPoison.Response{body: body}} ->
        Jason.decode(body)
    end
    |> Result.and_then(&add_to_args(args, :match_ids, &1))
  end

  defp get_match_history(%{match_ids: match_ids, region: region, platform: platform} = args) do
    match_history = Match.get_by_id(match_ids, region, platform)

    add_to_args(args, :match_history, match_history)
  end

  defp post_summoner_names(%{match_history: match_history, summoner: summoner} = args) do
    match_history
    |> Match.fetch_participant_names()
    |> Enum.reject(fn participant -> participant == Summoner.get_name(summoner) end)
    |> IO.inspect()

    args
  end

  defp add_to_args(args, key, value) do
    args
    |> Map.put(key, value)
    |> Result.ok()
  end
end
