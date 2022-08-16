defmodule Epoch.Mixfile do
  use Mix.Project

  def project do
    [
      app: :epoch,
      version: get_version(),
      elixir: "~> 1.6",
      elixirc_paths: elixirc_paths(Mix.env),
      compilers: [:gettext] ++ Mix.compilers,
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
      {:argon2_elixir, "~> 2.0"},
      {:corsica, "~> 1.0"},
      {:distillery, "~> 2.0"},
      {:ecto, "~> 3.7.1"},
      {:ecto_sql, "~> 3.7.2"},
      {:gettext, "~> 0.18"},
      {:guardian, "~> 2.0"},
      {:guardian_db, "~> 2.0"},
      {:guardian_redis, "~> 0.1.0"},
      {:iteraptor, "~> 1.13.1"},
      {:jason, "~> 1.2"},
      {:myxql, ">= 0.0.0"},
      {:phoenix, "~> 1.6.6"},
      {:plug_cowboy, "~> 2.5"},
      {:postgrex, ">= 0.16.1"},
      {:slugy, "~> 4.1.1"},
      {:uuid, "~> 1.1"}
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
    ["ecto.setup": ["ecto.create", "ecto.migrate"],
     "ecto.reset": ["ecto.drop", "ecto.setup"],
     "db.migrate": ["ecto.migrate", "ecto.dump"],
     "db.rollback": ["ecto.rollback", "ecto.dump"],
     "seed.permissions": ["run priv/repo/seed_permissions.exs"],
     "seed.prs": ["run priv/repo/seed_priority_restrictions.exs"],
     test: ["ecto.create --quiet", "ecto.migrate", "test"]]
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

  defp get_version do
    version_from_file()
    |> handle_file_version()
    |> String.replace_leading("v", "")
    |> String.trim
  end

  defp version_from_file(file \\ "VERSION"), do: File.read(file)

  defp handle_file_version({:ok, content}), do: content

  defp handle_file_version({:error, _}), do: retrieve_version_from_git()

  defp retrieve_version_from_git do
    System.cmd("git", ~w{describe --dirty --always --tags --first-parent})
    |> elem(0)
    |> String.trim
  end
end
