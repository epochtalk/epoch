defmodule Epoch.Repo.Migrations.CreatePosts do
  use Ecto.Migration

  def change do
    create table(:posts, primary_key: false) do
      add :id, :binary_id, primary_key: true, default: fragment("uuid_generate_v4()")
      add :thread_id, references(:threads, type: :uuid, on_delete: :delete_all, on_update: :update_all)
      add :user_id, references(:users, type: :uuid, on_delete: :delete_all, on_update: :update_all)
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

    execute """
    CREATE FUNCTION search_index_post() RETURNS trigger
        LANGUAGE plpgsql
        AS $$
      BEGIN
        -- increment users.profiles' post_count
        UPDATE posts SET
            tsv = x.tsv
        FROM (
            SELECT id,
                  setweight(to_tsvector('simple', COALESCE(content ->> 'title','')), 'A') ||
                  setweight(to_tsvector('simple', COALESCE(content ->> 'body','')), 'B')
                  AS tsv
            FROM posts WHERE id = NEW.id
        ) AS x
        WHERE x.id = posts.id;

        RETURN NEW;
      END;
    $$;
    """

    execute """
    CREATE TRIGGER search_index_post
    AFTER INSERT ON posts
    FOR EACH ROW EXECUTE PROCEDURE search_index_post()
    """
  end
end
