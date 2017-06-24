defmodule Epoch.Repo.Migrations.CreateAds do
  use Ecto.Migration

  def change do
    create table(:ads, primary_key: false) do
      add :id, :binary_id, primary_key: true, default: fragment("uuid_generate_v4()")
      add :round, :integer, null: false
      add :html, :text, null: false
      add :css, :text, default: "", null: false
      add :created_at, :timestamp
      add :updated_at, :timestamp
    end
  end
end
