defmodule Epoch.Repo.Migrations.CreateMetadata do
  use Ecto.Migration
  @schema_prefix "metadata"

  def change do
    execute "CREATE SCHEMA #{@schema_prefix}"

    create table(:boards, [prefix: @schema_prefix, primary_key: false]) do
      add :id, :binary_id, primary_key: true
      add :board_id, references(:boards, type: :uuid)
      add :post_count, :integer
      add :thread_count, :integer
      add :total_post, :integer
      add :total_thread_count, :integer
      add :last_post_username, :string
      add :last_post_created_at, :timestamp
      add :last_thread_id, :uuid
      add :last_thread_title, :string
      timestamps()
    end

    create index(:boards, [:board_id], prefix: @schema_prefix)

    create table(:threads, [prefix: @schema_prefix, primary_key: false]) do
      add :id, :binary_id, primary_key: true
      add :thread_id, references(:threads, type: :uuid)
      add :views, :integer, default: 0
    end

    create unique_index(:threads, [:thread_id], prefix: @schema_prefix)
  end
end
