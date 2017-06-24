defmodule Epoch.Repo.Migrations.PostgresConfig do
  use Ecto.Migration

  def change do
    execute "CREATE SCHEMA administration"
    execute "CREATE SCHEMA ads"
    execute "CREATE SCHEMA factoids"
    execute "CREATE SCHEMA mentions"
    execute "CREATE SCHEMA mod"
    execute "CREATE SCHEMA users"
    execute "CREATE EXTENSION IF NOT EXISTS citext WITH SCHEMA public"
    execute "CREATE EXTENSION IF NOT EXISTS \"uuid-ossp\" WITH SCHEMA public"
    execute "CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog"
  end
end
