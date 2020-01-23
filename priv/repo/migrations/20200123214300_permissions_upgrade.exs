defmodule Epoch.Repo.Migrations.PermissionsUpgrade do
  use Ecto.Migration

  def change do
    alter table(:roles) do
      add :custom_permissions, :jsonb
    end
  end
end
