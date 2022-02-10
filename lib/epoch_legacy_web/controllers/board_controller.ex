defmodule EpochLegacyWeb.Controllers.BoardController do
  use EpochWeb, :controller
  alias Epoch.Category
  alias EpochLegacyWeb.Views.BoardView

  def index(conn, _params) do
    categories_with_boards = Category
    |> Epoch.Repo.all()
    |> Epoch.Repo.preload(:boards)

    conn
    |> put_view(BoardView)
    |> render("index.json", categories_with_boards: categories_with_boards, threads: [])
  end

  def show(conn, %{"id" => id}) do
    board = SMF.Board.find_board(id)
    conn
    |> put_view(BoardView)
    |> render("show.json", board: board)
  end

  def id(conn, %{"slug" => _slug}) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, """
    {"id": 2}
    """)
  end
end