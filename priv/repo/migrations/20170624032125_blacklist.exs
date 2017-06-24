defmodule Epoch.Repo.Migrations.Blacklist do
  use Ecto.Migration

  def change do
    create table(:blacklist, primary_key: false) do
      add :id, :binary_id, primary_key: true, default: fragment("uuid_generate_v4()")
      add :ip_data, :string, size: 100, null: false
      add :note, :string
    end
  end
end
