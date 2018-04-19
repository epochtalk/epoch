defmodule Epoch.Repo.Migrations.Ranks do
  use Ecto.Migration

  def change do
    create table(:ranks, primary_key: false) do
      add(:id, :binary_id, primary_key: true, default: fragment("uuid_generate_v4()"))
      add(:rank_name, :text, null: false)
      add(:threshold, :integer, null: false)
    end

    create(index(:ranks, [:threshold]))

    create table(:users_ranks, primary_key: false) do
      add(:user_id, references(:users, type: :uuid, on_delete: :delete_all))
      add(:rank_id, references(:ranks, type: :uuid))
    end

    create(index(:users_ranks, [:user_id]))
    create(index(:users_ranks, [:rank_id]))
  end
end
