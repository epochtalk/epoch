defmodule Epoch.Repo.Migrations.CreateBoards do
  use Ecto.Migration

  def change do
    create table(:boards, primary_key: false) do
      add :id, :binary_id, [primary_key: true, default: fragment("uuid_generate_v4()")]
      add :name, :string
      add :description, :text
      add :post_count, :integer
      add :thread_count, :integer
      add :viewable_by, :integer
      add :postable_by, :integer
      add :created_at, :timestamp
      add :imported_at, :timestamp
      add :updated_at, :timestamp
    end
  end
end
