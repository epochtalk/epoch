defmodule Epoch.Repo.Migrations.AddPriorityRestrictions do
  use Ecto.Migration

  def change do
    create table(:priority_restrictions, primary_key: false) do
      add :role_lookup, references(:roles, column: :lookup, type: :string, on_delete: :delete_all), null: false, primary_key: true
      add :restrictions, {:array, :integer}
    end
  end
end
