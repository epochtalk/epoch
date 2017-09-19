defmodule Epoch.Repo.Migrations.ThreadSubscriptions do
  use Ecto.Migration
  @schema_prefix "users"

  def change do

    create table(:thread_subscriptions, [prefix: @schema_prefix, primary_key: false]) do
      add :user_id, :binary_id, null: false
      add :thread_id, :binary_id, null: false
    end

    create index(:thread_subscriptions, [:user_id], prefix: @schema_prefix)
    create index(:thread_subscriptions, [:thread_id], prefix: @schema_prefix)
    create unique_index(:thread_subscriptions, [:user_id, :thread_id], prefix: @schema_prefix)

    alter table(:preferences, [prefix: @schema_prefix]) do
      add :notify_created_threads, :boolean, default: true
      add :notify_replied_threads, :boolean, default: true
    end

  end
end
