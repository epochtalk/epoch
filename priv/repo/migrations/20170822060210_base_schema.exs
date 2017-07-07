defmodule Epoch.Repo.Migrations.BaseSchema do
  use Ecto.Migration

  def change do
    database = :epoch |> Application.get_env(Epoch.Repo) |> Keyword.get(:database)
    IO.puts "Loading Functions..."
    functions_path = Path.join [:code.priv_dir(:epoch), "repo", "migrations", "functions.sql"]
    System.cmd("psql",["-d", database, "-f", functions_path])

    IO.puts "Loading Triggers..."
    triggers_path = Path.join [:code.priv_dir(:epoch), "repo", "migrations", "triggers.sql"]
    System.cmd("psql",["-d", database, "-f", triggers_path])
  end
end
