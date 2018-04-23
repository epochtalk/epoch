defmodule Epoch.Repo.Migrations.Ranks do
  use Ecto.Migration

  def change do
    create table(:ranks, primary_key: false) do
      add(:name, :text, null: false)
      add(:number, :integer, null: false)
    end

    create(unique_index(:ranks, [:number]))

    create table(:metric_rank_map, primary_key: false) do
      add(:map, :jsonb, null: false)
    end
  end
end
