defmodule Blitzgg.Riot.RiotClient do
  @moduledoc """
  This module is a client for interfacing with the Riot Developers API.
  https://developer.riotgames.com/apis
  """

  @callback get_summoner_by_name(String.t(), String.t()) :: {:ok, HTTPoison.Response.t()}
  @callback get_summoner_by_puuid(String.t(), String.t()) :: {:ok, HTTPoison.Response.t()}
  @callback get_match_ids(String.t(), String.t(), integer()) :: {:ok, HTTPoison.Response.t()}
  @callback get_match_by_id(String.t(), String.t()) :: {:ok, HTTPoison.Response.t()}

  @doc """
  Function to retrieve summoner data from the Riot Developers API by summoner name.
  https://developer.riotgames.com/apis#summoner-v4

  """
  def get_summoner_by_name(summoner_name, platform) do
    get(
      "https://#{platform}.api.riotgames.com/lol/summoner/v4/summoners/by-name/#{summoner_name}"
    )
  end

  @doc """
  Function to retrieve summoner data from the Riot Developers API by summoner puuid.
  https://developer.riotgames.com/apis#summoner-v4

  """
  def get_summoner_by_puuid(puuid, platform) do
    get("https://#{platform}.api.riotgames.com/lol/summoner/v4/summoners/by-puuid/#{puuid}")
  end

  @doc """
  Function to retrieve match data for a given summoner and region.
  https://developer.riotgames.com/apis#match-v5
  """
  def get_match_ids(puuid, region, batch_size) do
    get(
      "https://#{region}.api.riotgames.com/lol/match/v5/matches/by-puuid/#{puuid}/ids?count=#{batch_size}"
    )
  end

  def get_match_by_id(match_id, region) do
    get("https://#{region}.api.riotgames.com/lol/match/v5/matches/#{match_id}")
  end

  defp get(url) do
    http_adapter().get(url, "X-Riot-Token": riot_api_key())
  end

  defp http_adapter do
    Application.get_env(:blitzgg, :riot_http_adapter)
  end

  defp riot_api_key do
    Application.get_env(:blitzgg, RiotClient)[:api_key]
  end
end
