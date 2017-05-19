defmodule Epoch.Repo.Migrations.BaseSchema do
  use Ecto.Migration

  def change do
    database = :epoch |> Application.get_env(Epoch.Repo) |> Keyword.get(:database)
    path = Path.join [:code.priv_dir(:epoch), "repo", "migrations", "schema.sql"]
    System.cmd("psql",["-d", database, "-f", path], into: IO.stream(:stdio, :line))
  end
end
