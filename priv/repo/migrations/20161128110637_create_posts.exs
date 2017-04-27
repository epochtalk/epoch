defmodule Epoch.Repo.Migrations.CreatePosts do
  use Ecto.Migration

  def change do
    create table(:posts, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :thread_id, references(:threads, type: :uuid)
      add :user_id, references(:users, type: :uuid)
      add :content, :jsonb
      add :deleted, :boolean
      add :locked, :boolean
      add :position, :integer
      add :tsv, :tsvector
      add :created_at, :timestamp
      add :imported_at, :timestamp
      timestamps
    end
    
    create index(:posts, [:thread_id])
    create index(:posts, [:user_id])
    create index(:posts, [:inserted_at])
    create index(:posts, [:thread_id, :position])
    create index(:posts, [:thread_id, :created_at])
    create index(:posts, [:user_id, :created_at])
    create index(:posts, [:thread_id, :user_id])
    create index(:posts, [:tsv])
  end
end
