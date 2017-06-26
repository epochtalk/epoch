defmodule Epoch.Repo.Migrations.FactoidsSchema do
  use Ecto.Migration
  @schema_prefix "factoids"

  def change do
    create table(:analytics, [prefix: @schema_prefix, primary_key: false]) do
      add :round, :integer, primary_key: true
      add :total_impressions, :integer, default: 0, null: false
      add :total_authed_impressions, :integer, default: 0, null: false
      add :total_unique_ip_impressions, :integer, default: 0, null: false
      add :total_unique_authed_users_impressions, :integer, default: 0, null: false
    end

    create table(:authed_users, [prefix: @schema_prefix, primary_key: false]) do
      add :round, :integer, null: false
      add :user_id, :binary_id, null: false
    end

    create index(:authed_users, [:round], prefix: @schema_prefix)
    create unique_index(:authed_users, [:round, :user_id], prefix: @schema_prefix)

    execute """
    ALTER TABLE ONLY #{@schema_prefix}.authed_users
    ADD CONSTRAINT authed_users_user_id_fkey
    FOREIGN KEY (user_id)
    REFERENCES public.users(id)
    ON DELETE SET NULL;
    """

    create table(:unique_ip, [prefix: @schema_prefix, primary_key: false]) do
      add :round, :integer, null: false
      add :unique_ip, :string, null: false
    end

    create index(:unique_ip, [:round], prefix: @schema_prefix)
    create unique_index(:unique_ip, [:round, :unique_ip], prefix: @schema_prefix)
  end
end
