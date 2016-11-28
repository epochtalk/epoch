defmodule Epoch.Repo.Migrations.CreateBoards do
  use Ecto.Migration

  def change do
    create table(:boards, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :description, :text
      add :post_count, :integer
      add :thread_count, :integer
      add :viewable_by, :integer
      add :imported_at, :timestamp
      timestamps
    end
  end
end
