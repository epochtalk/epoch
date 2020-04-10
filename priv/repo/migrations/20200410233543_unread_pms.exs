defmodule Epoch.Repo.Migrations.UnreadPms do
  use Ecto.Migration
  @schema_prefix "messages"
  def change do
    alter table(:private_conversations, [prefix: @schema_prefix]) do
      add :read_by_user_ids, {:array, :uuid}
    end
    alter table(:private_messages, [prefix: @schema_prefix]) do
      add :read_by_user_ids, {:array, :uuid}
    end
  end
end
