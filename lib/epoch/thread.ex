defmodule Epoch.Thread do
  use Ecto.Schema

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "threads" do
    belongs_to :board, Epoch.Board, type: :binary_id
    field :locked, :boolean
    field :sticky, :boolean
    field :moderated, :boolean
    field :post_count, :integer
    field :created_at, Ecto.DateTime
    field :imported_at, Ecto.DateTime
    field :updated_at, Ecto.DateTime
  end
end

