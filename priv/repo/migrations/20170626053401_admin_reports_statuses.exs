defmodule Epoch.Repo.Migrations.CreateAdminReportsStatuses do
  use Ecto.Migration
  @schema_prefix "administration"

  def change do
    create table(:reports_statuses, [prefix: @schema_prefix]) do
      add :priority, :integer, null: false
      add :status, :string, default: "", null: false
    end
  end
end
