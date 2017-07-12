defmodule Epoch.Board do
  use Ecto.Schema

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "boards" do
    field :name, :string
    field :description, :string
    field :post_count, :integer
    field :thread_count, :integer
    field :viewable_by, :integer
    field :postable_by, :integer
    field :created_at, Ecto.DateTime
    field :imported_at, Ecto.DateTime
    field :updated_at, Ecto.DateTime
    # field :meta, :jsonb
  end
end
