defmodule Blitzgg.Riot.LoL.SummonerSupervisor do
  @moduledoc """
  This dynamic supervisor is set up to monitor all instances of the SummonerWatcher.
  """

  use DynamicSupervisor

  alias Blitzgg.Riot.LoL.SummonerPoller

  @spec start_link(term()) :: {:ok, pid} | {:error, term()}
  def start_link(init_arg) do
    DynamicSupervisor.start_link(__MODULE__, init_arg, name: __MODULE__)
  end

  @impl DynamicSupervisor
  def init(_init_arg) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  @spec start_child(map()) :: {:ok, pid} | {:error, term()}
  def start_child(args) do
    DynamicSupervisor.start_child(__MODULE__, {SummonerPoller, args})
  end
end
