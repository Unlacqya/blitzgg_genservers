defmodule Blitzgg.Riot.LoL.RegionTest do
  use ExUnit.Case, async: true
  use ExUnit.Parameterized

  alias Blitzgg.Riot.LoL.Region

  describe "platform_to_region/1" do
    test_with_params "returns the correct region for each region platform",
                     fn platform, region ->
                       assert {:ok, ^region} = Region.platform_to_region(platform)
                     end do
      [
        {"BR1", "americas"},
        {"EUN1", "europe"},
        {"EUW1", "europe"},
        {"JP1", "asia"},
        {"KR", "asia"},
        {"LA1", "americas"},
        {"LA2", "americas"},
        {"NA1", "americas"},
        {"OC1", "sea"},
        {"TR1", "europe"},
        {"RU", "europe"},
        {"PH2", "sea"},
        {"SG2", "sea"},
        {"TH2", "sea"},
        {"TW2", "sea"},
        {"VN2", "sea"}
      ]
    end

    test "returns error tuple for invalid region platforms" do
      assert {:error, :invalid_platform} == Region.platform_to_region("USE1")
    end
  end
end
