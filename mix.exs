defmodule Blitzgg.MixProject do
  use Mix.Project

  def project do
    [
      app: :blitzgg,
      version: "0.1.0",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Blitzgg.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_parameterized, "~> 1.3.7"},
      {:fe, "~> 0.1.5"},
      {:httpoison, "~> 2.0"},
      {:jason, "~> 1.4"},
      {:mox, "~> 1.1.0", only: :test}
    ]
  end
end
