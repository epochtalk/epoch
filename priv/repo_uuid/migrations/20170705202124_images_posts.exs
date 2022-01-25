defmodule Epoch.Repo.Migrations.ImagesPosts do
  use Ecto.Migration

  def change do
    create table(:images_posts, primary_key: false) do
      add :id, :binary_id, primary_key: true, default: fragment("uuid_generate_v4()")
      add :post_id, references(:posts, [type: :uuid, on_delete: :nilify_all])
      add :image_url, :string, null: false
    end
    create index(:images_posts, [:post_id])
    create index(:images_posts, [:image_url])
  end
end
