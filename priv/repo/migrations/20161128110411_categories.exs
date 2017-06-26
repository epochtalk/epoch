defmodule Epoch.Repo.Migrations.CreateCategories do
  use Ecto.Migration

# CREATE TABLE categories (
#     id uuid DEFAULT uuid_generate_v4() NOT NULL,
#     name character varying(255) DEFAULT ''::character varying NOT NULL,
#     view_order integer,
#     imported_at timestamp with time zone,
#     viewable_by integer,
#     postable_by integer
# );

  def change do
    create table(:categories, primary_key: false) do
      add :id, :binary_id, primary_key: true, default: fragment("uuid_generate_v4()")
      add :name, :string
      add :view_order, :integer
      add :viewable_by, :integer
      add :postable_by, :integer
      add :created_at, :timestamp
      add :imported_at, :timestamp
      add :updated_at, :timestamp
      add :meta, :jsonb
    end
  end
end
