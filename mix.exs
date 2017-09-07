defmodule Epoch.Mixfile do
  use Mix.Project

  def project do
    [
      app: :epoch,
      version: "0.0.1",
      elixir: "~> 1.5",
      elixirc_paths: elixirc_paths(Mix.env),
      compilers: [:phoenix, :gettext] ++ Mix.compilers,
      start_permanent: Mix.env == :prod,
      aliases: aliases(),
      deps: deps(),
      description: description(),
      package: package()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {Epoch.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

    # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_),     do: ["lib"]

  defp deps do
    [
      {:distillery, "~> 1.4"},
      {:ecto, "~> 2.2.1"},
      {:phoenix, "~> 1.3"},
      {:phoenix_live_reload, "~> 1.0", only: :dev},
      {:postgrex, "~> 0.13.2"},
      {:gettext, "~> 0.11"},
      {:cowboy, "~> 1.0"}
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
