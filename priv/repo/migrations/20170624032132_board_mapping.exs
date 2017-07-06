defmodule Epoch.Repo.Migrations.BoardMapping do
  use Ecto.Migration

  def change do
    create table(:board_mapping, primary_key: false) do
      add :board_id, :binary_id, null: false
      add :parent_id, :binary_id
      add :category_id, :binary_id
      add :view_order, :integer, null: false
    end

    create index(:board_mapping, [:board_id])
  end
end
