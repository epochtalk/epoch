defmodule Epoch.Repo.Migrations.CreatePosts do
  use Ecto.Migration

  def change do
    create table(:posts, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :thread_id, references(:threads, type: :uuid)
      add :user_id, references(:users, type: :uuid)
      add :title, :string
      add :raw_body, :text
      add :body, :text
      add :deleted, :boolean
      add :locked, :boolean
      add :position, :integer
      add :tsv, :tsvector
      add :imported_at, :timestamp
      timestamps
    end

  end
end
