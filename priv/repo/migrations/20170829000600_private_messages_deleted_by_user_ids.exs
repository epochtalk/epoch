defmodule Epoch.Repo.Migrations.PrivateMessagesDeletedByUserIds do
  use Ecto.Migration

  def change do
    alter table(:private_conversations) do
      add :deleted_by_user_ids, {:array, :uuid}
    end
    alter table(:private_messages) do
      add :deleted_by_user_ids, {:array, :uuid}
      remove :copied_ids
    end
    execute """
    CREATE OPERATOR CLASS _uuid_ops DEFAULT
      FOR TYPE _uuid USING gin AS
      OPERATOR 1 &&(anyarray, anyarray),
      OPERATOR 2 @>(anyarray, anyarray),
      OPERATOR 3 <@(anyarray, anyarray),
      OPERATOR 4 =(anyarray, anyarray),
      FUNCTION 1 uuid_cmp(uuid, uuid),
      FUNCTION 2 ginarrayextract(anyarray, internal, internal),
      FUNCTION 3 ginqueryarrayextract(anyarray, internal, smallint,
    internal, internal, internal, internal),
      FUNCTION 4 ginarrayconsistent(internal, smallint, anyarray, integer,
    internal, internal, internal, internal),
      STORAGE uuid;
    """
    create index(:private_conversations, [:deleted_by_user_ids], name: :private_conversations_deleted_by_user_ids_gin, using: "GIN")
    create index(:private_messages, [:deleted_by_user_ids], name: :private_messages_deleted_by_user_ids_gin, using: "GIN")
  end
end
