defmodule Blitzgg.Riot.LoL.Match do
  alias Blitzgg.Riot.LoL.Summoner
  alias Blitzgg.Riot.RiotClient
  alias FE.Result

  defstruct [:match_id, :participants]

  def new(nil, _region), do: nil

  def new(match_json, platform) do
    {:ok, match} = Jason.decode(match_json)

    metadata = match["metadata"]

    %__MODULE__{
      match_id: metadata["matchId"],
      participants: Enum.map(metadata["participants"], &Summoner.get_by_puuid(&1, platform))
    }
  end

  def get_by_id(matches, region, platform) when is_list(matches) do
    Enum.map(matches, &get_by_id(&1, region, platform))
  end

  def get_by_id(match, region, platform) do
    match
    |> RiotClient.get_match_by_id(region)
    |> case do
      {:ok, %HTTPoison.Response{status_code: 403}} ->
        Result.error(:forbidden)

      {:ok, %HTTPoison.Response{status_code: 404}} ->
        Result.error(:match_not_found)

      {:ok, %HTTPoison.Response{body: body}} ->
        new(body, platform)
    end
  end

  def fetch_participant_names(matches) when is_list(matches) do
    matches
    |> Enum.map(&fetch_participant_names(&1))
    |> List.flatten()
    |> Enum.uniq()
  end

  def fetch_participant_names(%__MODULE__{participants: participants}) do
    Enum.map(participants, &Summoner.get_name(&1))
  end
end
