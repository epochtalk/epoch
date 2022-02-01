defmodule EpochWeb.Views.BoardView do
  use EpochWeb, :view

  def render("index.json", %{boards: boards}) do
    %{
      boards: Enum.map(boards, &board_json/1)
    }
  end

  def render("show.json", %{board: board}) do
    board
  end

  def board_json(board) do
    %{
      name: board.name,
      slug: board.slug
    }
  end
end