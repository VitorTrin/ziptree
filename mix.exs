defmodule Ziptree.MixProject do
  use Mix.Project

  def project do
    [
      app: :ziptree,
      version: "1.0.0",
      elixir: "~> 1.16",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      aliases: aliases(),
      preferred_cli_env: cli()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:rustler, "~> 0.30.0"},
      {:ex_doc, "~> 0.31.0", only: :dev, runtime: false},
      {:benchee, "~> 1.3", only: :test}
    ]
  end

  defp aliases do
    [
      test: ["test --exclude benchmark"],
      benchmark: ["test --only benchmark"]
    ]
  end

  defp cli do
    [
      {:benchmark, :test}
    ]
  end
end
