defmodule Blitzgg.Riot.LoL.SummonerPoller do
  @moduledoc """
  This gen server will monitor activity for a given summoner and region
  once every minute for one hour.
  """

  use GenServer, restart: :transient

  alias Blitzgg.Riot.LoL.Summoner

  alias FE.Result

  require Logger

  @type watcher_init_args :: %{
          subscription_pid: pid,
          summoner_name: String.t(),
          region: String.t(),
          platform: String.t(),
          summoner: Summoner.t()
        }

  @doc """

  """
  @spec start_link(watcher_init_args()) :: {:ok, pid()} | {:error, term()}
  def start_link(watcher_init_args) do
    GenServer.start_link(__MODULE__, watcher_init_args)
  end

  @impl GenServer
  def init(state) do
    pid = self()

    new_state =
      state
      |> Map.put(:polling_frequency, polling_frequency())
      |> Map.put(:poll_count, 0)
      |> Map.put(:pid, pid)

    {:ok, new_state, {:continue, :summoner_poll}}
  end

  @impl GenServer
  def handle_info(:summoner_poll, state) do
    new_state = poll_summoner(state)

    {:noreply, new_state}
  end

  @impl GenServer
  def handle_info(:stop_watching, state) do
    {:stop, :normal, state}
  end

  @impl GenServer
  def handle_info(_ignore, state), do: {:noreply, state}

  @impl GenServer
  def handle_continue(:summoner_poll, state) do
    new_state = poll_summoner(state)

    {:noreply, new_state}
  end

  defp poll_summoner(
         %{
           summoner: summoner,
           summoner_name: summoner_name,
           match_ids: existing_match_ids,
           region: region,
           poll_count: poll_count
         } = state
       ) do
    updated_match_ids =
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
      |> Result.and_then(&compare_match_ids(&1, existing_match_ids, summoner_name))

    state
    |> Map.put(:match_ids, updated_match_ids)
    |> Map.put(:poll_count, poll_count + 1)
    |> schedule_summoner_poll()
  end

  defp compare_match_ids(new_match_ids, existing_match_ids, summoner_name) do
    new_match_ids
    |> Enum.reject(fn match_id -> match_id in existing_match_ids end)
    |> Enum.each(&print_new_match(summoner_name, &1))

    Enum.uniq(new_match_ids ++ existing_match_ids)
  end

  defp print_new_match(summoner_name, match_id) do
    Logger.info("Summoner #{summoner_name} completed match #{match_id}")
  end

  defp schedule_summoner_poll(
         %{polling_frequency: polling_frequency, poll_count: poll_count, pid: pid} = state
       ) do
    if poll_count <= 60 do
      Process.send_after(pid, :summoner_poll, polling_frequency)

      state
    else
      Process.send(pid, :stop_watching, [])

      state
    end
  end

  defp polling_frequency do
    Application.get_env(:blitzgg, SummonerPoller)[:polling_frequency_ms]
  end
end
