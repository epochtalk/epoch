defmodule Epoch.Repo.Migrations.BoardModerators do
  use Ecto.Migration

  def change do
    create table(:board_moderators, primary_key: false) do
      add :user_id, :binary_id
      add :board_id, :binary_id
    end
  end
end
