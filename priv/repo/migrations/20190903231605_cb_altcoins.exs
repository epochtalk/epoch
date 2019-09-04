defmodule Elixir.Epoch.Repo.Migrations.CbAltcoins do
  use Ecto.Migration
  @schema_prefix "plugins"

  def up do
    execute "CREATE SCHEMA " <> @schema_prefix

    create table(:cb_projects, [prefix: @schema_prefix]) do
      add(:name, :text, null: false)
      add(:type, :text, null: false)
      add(:description, :text, null: false)
      add(:bct_ann, :text, null: false)
      add(:ann_date, :text, null: false)
      add(:website, :text, null: false)
      add(:flags, {:array, :uuid}, default: [])
      add(:badges, {:array, :uuid}, default: [])
    end

    create table(:cb_flags, [prefix: @schema_prefix]) do
      add(:name, :text, null: false)
      add(:description, :text, null: false)
      add(:user_text, :text, null: false)
      add(:user_url, :text, null: false)
      add(:supporting, {:array, :uuid}, default: [])
      add(:opposing, {:array, :uuid}, default: [])
    end

    create table(:cb_badges, [prefix: @schema_prefix]) do
      add(:name, :text, null: false)
      add(:description, :text, null: false)
    end
  end

  def down do
    drop table(:cb_projects, [prefix: @schema_prefix])
    drop table(:cb_flags, [prefix: @schema_prefix])
    drop table(:cb_badges, [prefix: @schema_prefix])
    execute "DROP SCHEMA " <> @schema_prefix
  end
end
