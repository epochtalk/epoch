defmodule Epoch.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def up do
    create table(:users, primary_key: false) do
      add :id, :binary_id, [primary_key: true, default: fragment("uuid_generate_v4()")]
      add :email, :citext, null: false
      add :username, :citext, null: false
      add :passhash, :string
      add :confirmation_token, :string
      add :reset_token, :string
      add :reset_expiration, :timestamp
      add :created_at, :timestamp
      add :imported_at, :timestamp
      add :updated_at, :timestamp
      add :deleted, :boolean, default: false
      add :malicious_score, :integer
    end
    create unique_index(:users, [:username])
    create unique_index(:users, [:email])
  end
end
