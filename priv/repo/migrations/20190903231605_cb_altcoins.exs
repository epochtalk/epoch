defmodule Elixir.Epoch.Repo.Migrations.CbAltcoins do
  use Ecto.Migration
  @schema_prefix "plugins"

  def up do
    execute "CREATE SCHEMA " <> @schema_prefix

    create table(:cb_cryptos, [prefix: @schema_prefix]) do
      add(:name, :text, null: false)
      add(:description, :text, null: false)
      add(:tracker, :text, null: false)
      add(:flags, {:array, :uuid}, default: [])
    end

    create table(:cb_exchanges, [prefix: @schema_prefix]) do
      add(:name, :text, null: false)
      add(:description, :text, null: false)
      add(:tracker, :text, null: false)
      add(:flags, {:array, :uuid}, default: [])
    end

    create table(:cb_services, [prefix: @schema_prefix]) do
      add(:name, :text, null: false)
      add(:description, :text, null: false)
      add(:tracker, :text, null: false)
      add(:flags, {:array, :uuid}, default: [])
    end

    create table(:cb_flags, [prefix: @schema_prefix]) do
      add(:name, :text, null: false)
      add(:description, :text, null: false)
      add(:supporting, {:array, :uuid}, default: [])
      add(:opposing, {:array, :uuid}, default: [])
    end

  end

  def down do
    drop table(:cb_cryptos, [prefix: @schema_prefix])
    drop table(:cb_exchanges, [prefix: @schema_prefix])
    drop table(:cb_services, [prefix: @schema_prefix])
    drop table(:cb_flags, [prefix: @schema_prefix])
    execute "DROP SCHEMA " <> @schema_prefix
  end
end
