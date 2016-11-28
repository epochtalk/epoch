defmodule Epoch.Repo.Migrations.CreateThreads do
  use Ecto.Migration

  def change do
    create table(:threads, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :board_id, references(:boards, type: :uuid)
      add :locked, :boolean
      add :sticky, :boolean
      add :moderated, :boolean
      add :post_count, :integer
      add :imported_at, :timestamp
      timestamps
    end
  end
end
