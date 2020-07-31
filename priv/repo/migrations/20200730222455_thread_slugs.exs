defmodule Epoch.Repo.Migrations.ThreadSlugs do
  use Ecto.Migration
  import Ecto.Query

  def up do
    alter table(:threads) do
      add :slug, :string, size: 100
    end

    create unique_index(:threads, [:slug])

    flush()

    from(t in "threads",
      update: [set: [slug: t.id]],
      where: true)
    |> Epoch.Repo.update_all([])

    alter table(:threads) do
      modify :slug, :string, size: 100, null: false
    end
  end

  def down do
    alter table(:threads) do
      remove :slug
    end
  end
end
