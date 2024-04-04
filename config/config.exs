import Config

config :blitzgg, :riot_http_adapter, HTTPoison

config :blitzgg, SummonerPoller, polling_frequency_ms: 1000
