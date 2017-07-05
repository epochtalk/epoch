defmodule Epoch.Repo.Migrations.Notifications do
  use Ecto.Migration

  def change do
    create table(:notifications, primary_key: false) do
      add :id, :binary_id, primary_key: true, default: fragment("uuid_generate_v4()")
      add :sender_id, references(:users, type: :uuid), null: false
      add :receiver_id, references(:users, type: :uuid), null: false
      add :data, :json
      add :created_at, :timestamp
      add :viewed, :boolean, default: false
      add :type, :string
    end

    create index(:notifications, [:type])
  end
end
