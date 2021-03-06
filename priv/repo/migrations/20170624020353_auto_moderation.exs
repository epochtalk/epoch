defmodule Epoch.Repo.Migrations.CreateAutoModeration do
  use Ecto.Migration

  def change do
    create table(:auto_moderation, primary_key: false) do
      add :id, :binary_id, primary_key: true, default: fragment("uuid_generate_v4()")
      add :name, :string, null: false
      add :description, :string, size: 1000
      add :message, :string, size: 1000
      add :conditions, :jsonb, null: false
      add :actions, :jsonb, null: false
      add :options, :jsonb
      add :created_at, :timestamp
      add :updated_at, :timestamp
    end
  end
end
