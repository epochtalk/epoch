defmodule Epoch.Repo.Migrations.CreatePosts do
  use Ecto.Migration

  def change do
    create table(:posts, primary_key: false) do
      add :id, :binary_id, primary_key: true, default: fragment("uuid_generate_v4()")
      add :thread_id, references(:threads, type: :uuid)
      add :user_id, references(:users, type: :uuid)
      add :content, :jsonb
      add :deleted, :boolean
      add :locked, :boolean
      add :position, :integer
      add :tsv, :tsvector
      add :created_at, :timestamp
      add :imported_at, :timestamp
      add :updated_at, :timestamp
    end
    
    create index(:posts, [:thread_id])
    create index(:posts, [:user_id])
    create index(:posts, [:thread_id, :position])
    create index(:posts, [:thread_id, :created_at])
    create index(:posts, [:user_id, :created_at])
    create index(:posts, [:thread_id, :user_id])
    create index(:posts, [:tsv], using: :gin)
  end
end
