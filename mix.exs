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
      {:dialyxir, "~> 0.4", only: [:dev]},
      {:distillery, "~> 2.0"},
      {:ecto, "~> 3.1.7"},
      {:ecto_sql, "~> 3.1.6"},
      {:postgrex, ">= 0.0.0"},
      {:gettext, "~> 0.14"},
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
    ["ecto.setup": ["ecto.create", "ecto.migrate"],
     "ecto.reset": ["ecto.drop", "ecto.setup"],
     "db.migrate": ["ecto.migrate", "ecto.dump"],
     "db.rollback": ["ecto.rollback", "ecto.dump"],
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
