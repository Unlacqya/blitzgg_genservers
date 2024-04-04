defmodule Blitzgg.Riot.LoL.Region do
  @moduledoc """

  """

  alias FE.Result

  @americas_platforms ["BR1", "LA1", "LA2", "NA1"]
  @asia_platforms ["JP1", "KR"]
  @europe_platforms ["EUN1", "EUW1", "TR1", "RU"]
  @sea_platforms ["OC1", "PH2", "SG2", "TH2", "TW2", "VN2"]

  defguardp is_americas(platform) when platform in @americas_platforms
  defguardp is_asia(platform) when platform in @asia_platforms
  defguardp is_europe(platform) when platform in @europe_platforms
  defguardp is_sea(platform) when platform in @sea_platforms

  @doc """
  Converts platform to region for use with the Riot API.
  """
  def platform_to_region(platform) do
    cond do
      is_americas(platform) -> Result.ok("americas")
      is_asia(platform) -> Result.ok("asia")
      is_europe(platform) -> Result.ok("europe")
      is_sea(platform) -> Result.ok("sea")
      true -> {:error, :invalid_platform}
    end
  end
end
