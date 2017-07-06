defmodule Epoch.Repo.Migrations.Roles do
  use Ecto.Migration

  def change do
    create table(:roles, primary_key: false) do
      add :id, :binary_id, primary_key: true, default: fragment("uuid_generate_v4()")
      add :name, :string, default: "", null: false
      add :description, :text, default: "", null: false
      add :permissions, :json
      add :created_at, :timestamp
      add :updated_at, :timestamp
      add :lookup, :string, null: false
      add :priority, :integer, null: false
      add :highlight_color, :string
    end

    create table(:roles_users, primary_key: false) do
      add :role_id, references(:roles, type: :uuid, on_delete: :delete_all)
      add :user_id, references(:users, type: :uuid, on_delete: :delete_all)
    end

    create unique_index(:roles, [:lookup])
  end
end
