defmodule Epoch.Repo.Migrations.MentionsSchema do
  use Ecto.Migration
  @schema_prefix "mentions"

  def change do
    create table(:ignored, [prefix: @schema_prefix, primary_key: false]) do
      add :user_id, :binary_id, null: false
      add :ignored_user_id, :binary_id, null: false
    end

    create index(:ignored, [:user_id], prefix: @schema_prefix)
    create index(:ignored, [:ignored_user_id], prefix: @schema_prefix)
    create unique_index(:ignored, [:user_id, :ignored_user_id], prefix: @schema_prefix)

    execute """
    ALTER TABLE ONLY #{@schema_prefix}.ignored
    ADD CONSTRAINT user_id_fkey
    FOREIGN KEY (user_id)
    REFERENCES public.users(id)
    ON DELETE CASCADE;
    """

    execute """
    ALTER TABLE ONLY #{@schema_prefix}.ignored
    ADD CONSTRAINT ignored_user_id_fkey
    FOREIGN KEY (ignored_user_id)
    REFERENCES public.users(id)
    ON DELETE CASCADE;
    """


    create table(:mentions, [prefix: @schema_prefix, primary_key: false]) do
      add :id, :binary_id, [primary_key: true, default: fragment("uuid_generate_v4()")]
      add :thread_id, :binary_id, null: false
      add :post_id, :binary_id, null: false
      add :mentioner_id, :binary_id, null: false
      add :mentionee_id, :binary_id, null: false
      add :created_at, :timestamp
    end

    execute """
    ALTER TABLE ONLY #{@schema_prefix}.mentions
    ADD CONSTRAINT mentions_thread_id_fkey
    FOREIGN KEY (thread_id)
    REFERENCES public.threads(id)
    ON DELETE CASCADE;
    """

    execute """
    ALTER TABLE ONLY #{@schema_prefix}.mentions
    ADD CONSTRAINT mentions_post_id_fkey
    FOREIGN KEY (post_id)
    REFERENCES public.posts(id)
    ON DELETE CASCADE;
    """

    execute """
    ALTER TABLE ONLY #{@schema_prefix}.mentions
    ADD CONSTRAINT mentions_mentioner_id_fkey
    FOREIGN KEY (mentioner_id)
    REFERENCES public.users(id)
    ON DELETE CASCADE;
    """

    execute """
    ALTER TABLE ONLY #{@schema_prefix}.mentions
    ADD CONSTRAINT mentions_mentionee_id_fkey
    FOREIGN KEY (mentionee_id)
    REFERENCES public.users(id)
    ON DELETE CASCADE;
    """
  end
end
