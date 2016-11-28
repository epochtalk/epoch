defmodule Epoch.Repo.Migrations.PostgresConfig do
  use Ecto.Migration

  def change do
    execute "CREATE EXTENSION IF NOT EXISTS citext"
    execute "CREATE EXTENSION IF NOT EXISTS \"uuid-ossp\""
  end
end
