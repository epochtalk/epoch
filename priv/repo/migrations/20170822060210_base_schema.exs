defmodule Epoch.Repo.Migrations.BaseSchema do
  use Ecto.Migration

  def change do
    database = :epoch |> Application.get_env(Epoch.Repo) |> Keyword.get(:database)
    IO.puts "Loading functions"
    functions_path = Path.join [:code.priv_dir(:epoch), "repo", "migrations", "functions.sql"]
    System.cmd("psql",["-d", database, "-f", functions_path])

    schema_path = Path.join [:code.priv_dir(:epoch), "repo", "migrations", "schema.sql"]
    System.cmd("psql",["-d", database, "-f", schema_path], into: IO.stream(:stdio, :line))
  end
end
