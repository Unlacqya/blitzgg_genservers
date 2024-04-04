defmodule Blitzgg.Riot.LoL.WorkerTest do
  use ExUnit.Case, async: false

  import ExUnit.CaptureIO
  import Mox

  alias Blitzgg.Riot.LoL.Worker
  alias Blitzgg.Riot.MockRiotClient

  @summoner_name "DeathcapForCutey"
  @platform "NA1"

  describe "main/0" do
    test "success case" do
    end

    test "invalid platform case" do
      platform = "NA10"

      assert "Invalid region platform, please try again." ==
               capture_io(
                 [input: "#{@summoner_name}\n#{platform}\n", capture_prompt: false],
                 fn -> Worker.main() end
               )
    end

    test "invalid summoner case" do
      summoner_name = "iosfoiewfoiwjefpojiojhefoihj"

      expect(MockRiotClient, :get_summoner_by_name, fn _name, _platform ->
        {:ok, %HTTPoison.Response{status_code: 404}}
      end)

      assert "Summoner not found, please try again." ==
               capture_io(
                 [input: "#{summoner_name}\n#{@platform}\n", capture_prompt: false],
                 fn -> Worker.main() end
               )
    end

    test "invalid API key case" do
      expect(MockRiotClient, :get_summoner_by_name, fn _name, _platform ->
        {:ok, %HTTPoison.Response{status_code: 403}}
      end)

      assert "Access to Riot API forbidden, do you have a valid API key?" ==
               capture_io(
                 [input: "#{@summoner_name}\n#{@platform}\n", capture_prompt: false],
                 fn -> Worker.main() end
               )
    end
  end
end
