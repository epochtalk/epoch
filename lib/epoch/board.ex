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
    field :created_at, :naive_datetime
    field :imported_at, :naive_datetime
    field :updated_at, :naive_datetime
    field :meta, :map
    many_to_many :categories, Epoch.Category, join_through: "board_mapping"
  end
end