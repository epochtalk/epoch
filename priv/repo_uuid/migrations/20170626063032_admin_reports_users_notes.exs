defmodule Epoch.Repo.Migrations.CreateAdminReportsUsersNotes do
  use Ecto.Migration
  @schema_prefix "administration"

  def change do
    create table(:reports_users_notes, [prefix: @schema_prefix, primary_key: false]) do
      add :id, :binary_id, [primary_key: true, default: fragment("uuid_generate_v4()")]
      add :report_id, references(:reports_users, type: :uuid, on_delete: :delete_all)
      add :user_id, :binary_id
      add :note, :text, default: "", null: false
      add :created_at, :timestamp
      add :updated_at, :timestamp
    end
    
    create index(:reports_users_notes, [:created_at], prefix: @schema_prefix)
    create index(:reports_users_notes, [:report_id], prefix: @schema_prefix)

    execute """
    ALTER TABLE ONLY #{@schema_prefix}.reports_users_notes
    ADD CONSTRAINT user_id_fkey
    FOREIGN KEY (user_id)
    REFERENCES public.users(id)
    ON DELETE SET NULL;
    """
  end
end
