defmodule Epoch.Category do
  use Ecto.Schema

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "categories" do
    field :name, :string
    field :view_order, :integer
    field :viewable_by, :integer
    field :postable_by, :integer
    field :created_at, :naive_datetime
    field :imported_at, :naive_datetime
    field :updated_at, :naive_datetime
    field :meta, :map
    many_to_many :boards, Epoch.Board, join_through: "board_mapping"
  end
end