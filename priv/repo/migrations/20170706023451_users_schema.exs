defmodule Epoch.Repo.Migrations.UsersSchema do
  use Ecto.Migration
  @schema_prefix "users"

  def change do
    create table(:bans, [prefix: @schema_prefix, primary_key: false]) do
      add :id, :binary_id, [primary_key: true, default: fragment("uuid_generate_v4()")]
      add :user_id, :binary_id, null: false
      add :expiration, :timestamp, null: false
      add :created_at, :timestamp
      add :updated_at, :timestamp
    end

    create unique_index(:bans, [:user_id], prefix: @schema_prefix)

    create table(:board_bans, [prefix: @schema_prefix, primary_key: false]) do
      add :user_id, :binary_id, null: false
      add :board_id, :binary_id, null: false
    end

    create index(:board_bans, [:board_id], prefix: @schema_prefix)
    create index(:board_bans, [:user_id], prefix: @schema_prefix)
    create unique_index(:board_bans, [:board_id, :user_id], prefix: @schema_prefix)

    create table(:ignored, [prefix: @schema_prefix, primary_key: false]) do
      add :user_id, :binary_id, null: false
      add :ignored_user_id, :binary_id, null: false
      add :created_at, :timestamp
    end

    create index(:ignored, [:user_id], prefix: @schema_prefix)
    create index(:ignored, [:ignored_user_id], prefix: @schema_prefix)
    create unique_index(:ignored, [:user_id, :ignored_user_id], prefix: @schema_prefix)

    create table(:ips, [prefix: @schema_prefix, primary_key: false]) do
      add :user_id, :binary_id, null: false
      add :user_ip, :string, null: false
      add :created_at, :timestamp
    end

    create index(:ips, [:created_at], prefix: @schema_prefix)
    create index(:ips, [:user_id], prefix: @schema_prefix)
    create index(:ips, [:user_ip], prefix: @schema_prefix)
    create unique_index(:ips, [:user_id, :user_ip], prefix: @schema_prefix)

    create table(:preferences, [prefix: @schema_prefix, primary_key: false]) do
      add :user_id, :binary_id, null: false
      add :posts_per_page, :integer, default: 25
      add :threads_per_page, :integer, default: 25
      add :collapsed_categories, :json, default: fragment("'{\"cats\": []}'::json")
    end

    create table(:profiles, [prefix: @schema_prefix, primary_key: false]) do
      add :id, :binary_id, [primary_key: true, default: fragment("uuid_generate_v4()")]
      add :user_id, :binary_id
      add :avatar, :string
      add :position, :string
      add :signature, :text
      add :post_count, :integer, default: 0
      add :fields, :json
      add :raw_signature, :text
      add :last_active, :timestamp
    end

    create table(:thread_views, [prefix: @schema_prefix, primary_key: false]) do
      add :user_id, :binary_id
      add :thread_id, :binary_id
      add :time, :timestamp
    end

    create table(:watch_boards, [prefix: @schema_prefix, primary_key: false]) do
      add :user_id, :binary_id
      add :board_id, :binary_id
    end

    create table(:watch_threads, [prefix: @schema_prefix, primary_key: false]) do
      add :user_id, :binary_id
      add :thread_id, :binary_id
    end

  end
end
