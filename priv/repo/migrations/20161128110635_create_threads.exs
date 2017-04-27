defmodule Epoch.Repo.Migrations.CreateThreads do
  use Ecto.Migration

  def change do
    create table(:threads, primary_key: false) do
      add :id, :binary_id, [primary_key: true, default: fragment("uuid_generate_v4()")]
      add :board_id, references(:boards, type: :uuid)
      add :locked, :boolean
      add :sticky, :boolean
      add :moderated, :boolean
      add :post_count, :integer
      add :created_at, :timestamp
      add :imported_at, :timestamp
      add :updated_at, :timestamp
    end
  end
end
