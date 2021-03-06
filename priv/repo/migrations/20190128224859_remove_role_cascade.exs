defmodule Elixir.Epoch.Repo.Migrations.RemoveRoleCascade do
  use Ecto.Migration

  def up do
    execute "ALTER TABLE roles_users DROP CONSTRAINT roles_users_role_id_fkey"
    alter table(:roles_users) do
      modify :role_id, references(:roles, type: :uuid, on_delete: :nothing)
    end
  end

  def down do
    execute "ALTER TABLE roles_users DROP CONSTRAINT roles_users_role_id_fkey"
    alter table(:roles_users) do
      modify :role_id, references(:roles, type: :uuid, on_delete: :delete_all)
    end
  end

end
