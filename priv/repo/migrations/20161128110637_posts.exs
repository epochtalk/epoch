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

    execute """
    CREATE FUNCTION create_post() RETURNS trigger
        LANGUAGE plpgsql
        AS $$
      BEGIN
        -- LOCKS
        PERFORM 1 FROM threads WHERE id = NEW.thread_id FOR UPDATE;
        PERFORM 1 FROM users.profiles WHERE user_id = NEW.user_id FOR UPDATE;

        -- increment users.profiles' post_count
        UPDATE users.profiles SET post_count = post_count + 1 WHERE user_id = NEW.user_id;

        -- update thread's created_at
        UPDATE threads SET created_at = (SELECT created_at FROM posts WHERE thread_id = NEW.thread_id ORDER BY created_at limit 1) WHERE id = NEW.thread_id;

        -- update thread's updated_at
        UPDATE threads SET updated_at = (SELECT created_at FROM posts WHERE thread_id = NEW.thread_id ORDER BY created_at DESC limit 1) WHERE id = NEW.thread_id;

        -- update with post position and account for deleted (hidden) posts
        UPDATE posts SET position = (SELECT post_count + 1 + (SELECT COUNT(*) FROM posts WHERE thread_id = NEW.thread_id AND deleted = true) FROM threads WHERE id = NEW.thread_id) WHERE id = NEW.id;

        -- increment metadata.threads' post_count
        UPDATE threads SET post_count = post_count + 1 WHERE id = NEW.thread_id;

        RETURN NEW;
      END;
    $$;
    """
    
    execute """
    CREATE TRIGGER create_post_trigger
    AFTER INSERT ON posts
    FOR EACH ROW EXECUTE PROCEDURE create_post()
    """

    execute """
    CREATE FUNCTION delete_post() RETURNS trigger
        LANGUAGE plpgsql
        AS $$
      BEGIN
        -- LOCKS
        PERFORM 1 FROM threads WHERE id = OLD.thread_id FOR UPDATE;
        PERFORM 1 FROM users.profiles WHERE user_id = OLD.user_id FOR UPDATE;

        -- ONLY UPDATE COUNTS IF THE POST ISN'T ALREADY DELETED/HIDDEN
        IF (OLD.deleted != true) THEN
          -- decrement users.profiles' post_count
          UPDATE users.profiles SET post_count = post_count - 1 WHERE user_id = OLD.user_id;

          -- update thread's updated_at to last post available
          UPDATE threads SET updated_at = (SELECT created_at FROM posts WHERE thread_id = OLD.thread_id ORDER BY created_at DESC limit 1) WHERE id = OLD.thread_id;
        END IF;

        -- update post positions for all higher post positions
        UPDATE posts SET position = position - 1 WHERE position > OLD.position AND thread_id = OLD.thread_id;

        -- ONLY UPDATE COUNTS IF THE POST ISN'T ALREADY DELETED/HIDDEN
        IF (OLD.deleted != true) THEN
          -- decrement metadata.threads' post_count
          UPDATE threads SET post_count = post_count - 1 WHERE id = OLD.thread_id;
        END IF;

        RETURN OLD;
      END;
    $$;
    """

    execute """
    CREATE TRIGGER delete_post_trigger
    AFTER DELETE ON posts
    FOR EACH ROW EXECUTE PROCEDURE delete_post()
    """

    execute """
CREATE FUNCTION hide_post() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
  BEGIN
      -- LOCKS
      PERFORM 1 FROM threads WHERE id = OLD.thread_id FOR UPDATE;
      PERFORM 1 FROM users.profiles WHERE user_id = OLD.user_id FOR UPDATE;

      -- decrement users.profiles' post_count
      UPDATE users.profiles SET post_count = post_count - 1 WHERE user_id = OLD.user_id;

      -- update thread's updated_at to last post available
      UPDATE threads SET updated_at = (SELECT created_at FROM posts WHERE thread_id = OLD.thread_id ORDER BY created_at DESC limit 1) WHERE id = OLD.thread_id;

      -- decrement metadata.threads' post_count
      UPDATE threads SET post_count = post_count - 1 WHERE id = OLD.thread_id;

      RETURN OLD;
  END;
$$;
    """

    execute """
    CREATE TRIGGER hide_post_trigger
    AFTER UPDATE ON posts
    FOR EACH ROW WHEN (((old.deleted = false)
    AND (new.deleted = true)))
    EXECUTE PROCEDURE hide_post()
    """

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

    execute """
CREATE FUNCTION unhide_post() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
  BEGIN
      -- LOCKS
      PERFORM 1 FROM threads WHERE id = NEW.thread_id FOR UPDATE;
      PERFORM 1 FROM users.profiles WHERE user_id = NEW.user_id FOR UPDATE;

      -- increment users.profiles' post_count
      UPDATE users.profiles SET post_count = post_count + 1 WHERE user_id = NEW.user_id;

      -- update thread's created_at
      UPDATE threads SET created_at = (SELECT created_at FROM posts WHERE thread_id = NEW.thread_id ORDER BY created_at limit 1) WHERE id = NEW.thread_id;

      -- update thread's updated_at
      UPDATE threads SET updated_at = (SELECT created_at FROM posts WHERE thread_id = NEW.thread_id ORDER BY created_at DESC limit 1) WHERE id = NEW.thread_id;

      -- increment metadata.threads' post_count
      UPDATE threads SET post_count = post_count + 1 WHERE id = NEW.thread_id;
    RETURN NEW;
  END;
$$;
    """

    execute """
    CREATE TRIGGER unhide_post_trigger
    AFTER UPDATE ON posts
    FOR EACH ROW WHEN (((old.deleted = true)
    AND (new.deleted = false)))
    EXECUTE PROCEDURE unhide_post()
    """
  end
end
