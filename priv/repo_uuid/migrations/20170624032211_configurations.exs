defmodule Epoch.Repo.Migrations.Configurations do
  use Ecto.Migration

  def change do
    create table(:configurations, primary_key: false) do
      add :id, :binary_id, [primary_key: true, default: fragment("uuid_generate_v4()")]
      add :name, :string
      add :config, :jsonb
    end
    create unique_index(:configurations, [:name])
  end
end
