defmodule Epoch.BoardMapping do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  schema "board_mapping" do
    belongs_to :board, Epoch.Board
    belongs_to :parent, Epoch.Board
    belongs_to :category, Epoch.Category
    field :view_order, :integer
  end

  def changeset(board_mapping, attrs) do
    board_mapping
    |> cast(attrs, [:board_id, :parent_id, :category_id, :view_order])
    |> foreign_key_constraint(:parent_id, name: :board_mapping_parent_id_fkey)
    |> unique_constraint([:board_id, :parent_id], name: :board_mapping_board_id_parent_id_index)
    |> unique_constraint([:board_id, :category_id], name: :board_mapping_board_id_category_id_index)
  end
end