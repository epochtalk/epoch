defmodule Epoch.Repo.Migrations.CreateAdminReportsMessagesNotes do
  use Ecto.Migration
  
  @schema_prefix "administration"

  def change do
    create table(:reports_messages_notes, [prefix: @schema_prefix, primary_key: false]) do
      add :id, :binary_id, primary_key: true, default: fragment("uuid_generate_v4()")
      add :report_id, :binary_id, null: false
      add :user_id, :binary_id
      add :note, :text, default: "", null: false
      add :created_at, :timestamp
      add :updated_at, :timestamp
    end
  end
end
