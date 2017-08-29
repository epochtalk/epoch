defmodule Epoch.Mixfile do
  use Mix.Project

  def project do
    [app: :epoch,
     version: "0.0.1",
     elixir: "~> 1.4",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     aliases: aliases(),
     deps: deps(),
     description: description(),
     package: package()]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {Epoch, []},
      applications: [:logger, :ecto, :postgrex]
    ]
  end

  defp deps do
    [
      {:distillery, "~> 1.4"},
      {:ecto, "~> 2.2.1"},
      {:postgrex, "~> 0.13.2"}
    ]
  end

  defp description do
    """
    The Epoch forum database schema layer.
    """
  end

  # ecto.setup - create/migrate/seed
  # ecto.reset - drop/setup
  defp aliases do
    ["ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
     "ecto.reset": ["ecto.drop", "ecto.setup"],
     "db.migrate": ["ecto.migrate", "ecto.dump"],
     "db.rollback": ["ecto.rollback", "ecto.dump"],
     "test": ["ecto.create --quiet", "ecto.migrate", "test"]]
  end

  defp package do
    # These are the default files included in the package
    [
      name: :epoch,
      maintainers: ["Jian Shi Wang"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/epochtalk/epoch"}
    ]
  end
end
