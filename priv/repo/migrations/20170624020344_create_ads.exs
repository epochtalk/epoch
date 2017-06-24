defmodule Epoch.Repo.Migrations.CreateAds do
  use Ecto.Migration

  def change do
    create table(:ads, primary_key: false) do
      add :id, :binary_id, primary_key: true, default: fragment("uuid_generate_v4()")
      add :user_id, :binary_id
      add :thread_id, :binary_id
      add :post_id, :binary_id
      add :reason_subject, :string
      add :reason_body, :text, default: ""
      add :created_at, :timestamp
      add :imported_at, :timestamp
      add :updated_at, :timestamp
    end
  end
end
