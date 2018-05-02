defmodule Epoch.Repo.Migrations.BctMerit do
  use Ecto.Migration

  def change do
    # - Table smf_merit_ledger(ID_MEMBER_FROM unsigned, ID_MEMBER_TO unsigned, ID_MSG unsigned, amount int, time unsigned)
    create table(:merit_ledger, primary_key: false) do
      add(:from_user_id, references(:users, type: :uuid))
      add(:to_user_id, references(:users, type: :uuid))
      add(:post_id, references(:posts, type: :uuid))
      add(:amount, :integer, null: false)
      add(:created_at, :timestamp)
    end

    create(index(:merit_ledger, [:amount]))
    create(index(:merit_ledger, [:created_at]))

    # - Table smf_merit_sources(ID_MEMBER unsigned, time unsigned, amount unsigned)
    create table(:merit_sources, primary_key: false) do
      add(:user_id, references(:users, type: :uuid, on_delete: :delete_all))
      add(:amount, :integer, null: false)
      add(:created_at, :timestamp)
    end

    create(index(:merit_sources, [:amount]))
    create(index(:merit_sources, [:created_at]))

    # - Column merit in smf_members, which is just a cached calculation from smf_merit_ledger
    create table(:merit_users, primary_key: false) do
      add(:user_id, references(:users, type: :uuid, on_delete: :delete_all))
      add(:amount, :integer, null: false)
    end

    create(index(:merit_users, [:amount]))
  end
end
