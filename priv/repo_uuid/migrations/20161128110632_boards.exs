defmodule Epoch.Repo.Migrations.CreateBoards do
  use Ecto.Migration

  def change do
    create table(:boards, primary_key: false) do
      add :id, :binary_id, primary_key: true, default: fragment("uuid_generate_v4()")
      add :name, :string, default: ""
      add :description, :text, default: ""
      add :post_count, :integer, default: 0
      add :thread_count, :integer, default: 0
      add :viewable_by, :integer
      add :postable_by, :integer
      add :created_at, :timestamp
      add :imported_at, :timestamp
      add :updated_at, :timestamp
      add :meta, :jsonb
    end
  end
end
