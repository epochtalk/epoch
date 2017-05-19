defmodule Epoch.ReleaseTasks do
  @start_apps [
    :postgrex,
    :ecto
  ]

  @apps [
    :epoch
  ]

  @repos [
    Epoch.Repo
  ]

  def migrate do
    IO.puts "Loading epoch.."
    # Load the code for epoch, but don't start it
    :ok = Application.load(:epoch)

    IO.puts "Starting dependencies.."
    # Start apps necessary for executing migrations
    Enum.each(@start_apps, &Application.ensure_all_started/1)

    # Start the Repo(s) for epoch
    IO.puts "Starting repos.."
    Enum.each(@repos, &(&1.start_link(pool_size: 1)))

    # Run migrations
    Enum.each(@apps, &run_migrations_for/1)


    # Signal shutdown
    IO.puts "Success!"
    :init.stop()
  end

  def priv_dir(app), do: "#{:code.priv_dir(app)}"

  defp run_migrations_for(app) do
    IO.puts "Running migrations for #{app}"
    Ecto.Migrator.run(Epoch.Repo, migrations_path(app), :up, all: true)
  end

  defp migrations_path(app), do: Path.join([priv_dir(app), "repo", "migrations"])
  defp seed_path(app), do: Path.join([priv_dir(app), "repo", "seeds.exs"])
end
