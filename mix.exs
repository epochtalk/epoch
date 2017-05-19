defmodule Epoch.Mixfile do
  use Mix.Project

  def project do
    [app: :epoch,
     version: "0.0.1",
     elixir: "~> 1.4",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     aliases: aliases(),
     deps: deps()]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [applications: [:logger, :ecto, :postgrex]]
  end

  defp deps do
    [
      {:distillery, "~> 1.4", warn_missing: false},
      {:ecto, "~> 2.1"},
      {:postgrex, "~> 0.13.2"}
    ]
  end

  # ecto.setup - create/migrate/seed
  # ecto.reset - drop/setup
  defp aliases do
    ["ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
     "ecto.reset": ["ecto.drop", "ecto.setup"],
     "test": ["ecto.create --quiet", "ecto.migrate", "test"]]
  end
end
