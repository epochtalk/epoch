defmodule Epoch.Repo.Migrations.CreateMetadata do
  use Ecto.Migration
  @schema_prefix "metadata"

  def change do
    execute "CREATE SCHEMA #{@schema_prefix}"

    create table(:boards, [prefix: @schema_prefix, primary_key: false]) do
      add :id, :binary_id, primary_key: true, default: fragment("uuid_generate_v4()")
      add :board_id, :binary_id
      add :post_count, :integer
      add :thread_count, :integer
      add :total_post, :integer
      add :total_thread_count, :integer
      add :last_post_username, :string
      add :last_post_created_at, :timestamp
      add :last_thread_id, :uuid
      add :last_thread_title, :string
    end

    execute("ALTER TABLE ONLY metadata.boards ADD CONSTRAINT boards_board_id_fkey FOREIGN KEY (board_id) REFERENCES public.boards(id) ON UPDATE CASCADE ON DELETE CASCADE")

    create index(:boards, [:board_id], prefix: @schema_prefix)

    create table(:threads, [prefix: @schema_prefix, primary_key: false]) do
      add :id, :binary_id, primary_key: true, default: fragment("uuid_generate_v4()") 
      add :thread_id, references(:threads, type: :uuid)
      add :views, :integer, default: 0
    end

    create unique_index(:threads, [:thread_id], prefix: @schema_prefix)
  end
end
