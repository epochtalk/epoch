defmodule Epoch.Thread do
  use Ecto.Schema

  schema "threads" do
    belongs_to :board, Epoch.Board
    field :locked, :boolean
    field :sticky, :boolean
    field :slug, :string
    field :moderated, :boolean
    field :post_count, :integer
    field :created_at, :naive_datetime
    field :imported_at, :naive_datetime
    field :updated_at, :naive_datetime
    has_many :posts, Epoch.Post
  end
end

