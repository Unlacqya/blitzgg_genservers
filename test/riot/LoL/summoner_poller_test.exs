# defmodule Blitzgg.Riot.LoL.SummonerPollerTest do
#   use ExUnit.Case, async: false

#   import Mox

#   alias Blitzgg.Riot.LoL.{Summoner, SummonerPoller}
#   alias Blitzgg.Riot.MockRiotClient

#   @puuid "hsIKFxuQa9hQ1edDQFNAf7QQFZrBDdv2nHrNj0DQ9UImcuxvfVRfMv_Jrn_OS-UsXa-Wevq1Y74YNA"
#   @region "americas"

#   @init_state %{
#     summoner_name: "DeathcapForCutey",
#     platform: "NA1",
#     region: @region,
#     match_ids: ["match_1", "match_2", "match_3", "match_4", "match_5"],
#     polling_frequency: 1000,
#     summoner: %Summoner{
#       account_id: "mF9sycQRYf2FoocJXpdq6qwuA--VSD67E92A4LffH2uAKec",
#       riot_id: "-cHcwnZpPgIpiihpvqSJZSvfAF7mEgc2Jmcsnkt5e1-Os9Y",
#       name: "DeathcapForCutey",
#       puuid: @puuid
#     }
#   }

#   describe "handle_info/2" do
#     setup :set_mox_from_context
#     setup :verify_on_exit!

#     test "polls for summoner, no new matches" do
#       expect(MockRiotClient, :get_match_ids, fn _puuid, _region, _batch_size ->
#         {:ok,
#          %HTTPoison.Response{
#            body: "[\"match_1\",\"match_2\",\"match_3\",\"match_4\",\"match_5\"]"
#          }}
#       end)

#       assert {:noreply, @init_state} = SummonerPoller.handle_info(:summoner_poll, @init_state)
#     end

#     test "polls for summoner, new matches" do
#     end
#   end

#   describe "handle_continue/2" do
#     test "polls for summoner, no new matches" do
#     end

#     test "polls for summoner, new matches" do
#     end
#   end
# end
