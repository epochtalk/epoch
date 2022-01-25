defmodule Epoch.Repo.Migrations.CreateFactoids do
  use Ecto.Migration

  # move to after admin
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
