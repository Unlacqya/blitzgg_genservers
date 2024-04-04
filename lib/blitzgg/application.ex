defmodule Blitzgg.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  alias Blitzgg.Riot.LoL.SummonerSupervisor

  @impl true
  def start(_type, _args) do
    children = [
      SummonerSupervisor
      # Starts a worker by calling: Blitzgg.Worker.start_link(arg)
      # {Blitzgg.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Blitzgg.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
