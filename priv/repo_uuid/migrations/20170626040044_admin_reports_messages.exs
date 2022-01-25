defmodule Epoch.Repo.Migrations.CreateAdminReportsMessages do
  use Ecto.Migration

  @schema_prefix "administration"

  def change do
    create table(:reports_messages, [prefix: @schema_prefix, primary_key: false]) do
      add :id, :binary_id, primary_key: true, default: fragment("uuid_generate_v4()")
      add :status, :report_status_type, default: fragment("'Pending'::report_status_type"), null: false
      add :reporter_user_id, :binary_id
      add :reporter_reason, :text, default: "", null: false
      add :reviewer_user_id, :binary_id
      add :offender_message_id, :binary_id, null: false
      add :created_at, :timestamp
      add :updated_at, :timestamp
    end

    create unique_index(:reports_messages, [:offender_message_id, :reporter_user_id], prefix: @schema_prefix)
    create index(:reports_messages, [:created_at], prefix: @schema_prefix)
  end
end
