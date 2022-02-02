defmodule Epoch.Thread do
  use Ecto.Schema
  import Ecto.Changeset

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
    field :smf_topic, :map, virtual: true
  end

  def changeset(thread, attrs) do
    thread
    |> cast(attrs, [:id, :board_id, :slug, :moderated, :post_count, :created_at, :imported_at, :updated_at])
    |> unique_constraint(:id, name: :threads_pkey)
    |> unique_constraint(:slug, name: :threads_slug_index)
    |> foreign_key_constraint(:board_id, name: :threads_board_id_fkey)
  end
end