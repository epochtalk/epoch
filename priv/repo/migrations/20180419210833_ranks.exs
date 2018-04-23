defmodule Epoch.Repo.Migrations.Ranks do
  use Ecto.Migration

  def change do
    create table(:ranks, primary_key: false) do
      add(:id, :binary_id, primary_key: true, default: fragment("uuid_generate_v4()"))
      add(:name, :text, null: false)
      add(:ranking, :integer, null: false)
    end

    create(unique_index(:ranks, [:ranking]))

    create table(:ranks_thresholds, primary_key: false) do
      add(:rank_id, references(:ranks, type: :uuid, on_delete: :delete_all))
      add(:thresholds, :jsonb)
    end
  end
end
