defmodule Epoch.Repo.Migrations.CreateFactoids do
  use Ecto.Migration

  # CREATE TABLE factoids (
  #     id uuid DEFAULT uuid_generate_v4() NOT NULL,
  #     text text NOT NULL,
  #     enabled boolean DEFAULT true,
  #     created_at timestamp with time zone,
  #     updated_at timestamp with time zone
  # );
  #
  def change do
    create table(:factoids, primary_key: false) do
      add :id, :binary_id, primary_key: true, default: fragment("uuid_generate_v4()")
      add :text, :text, null: false
      add :enabled, :boolean, default: true
      add :created_at, :timestamp
      add :updated_at, :timestamp
    end

    create index(:factoids, [:created_at])
    create index(:factoids, [:enabled])
  end
end
