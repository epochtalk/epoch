defmodule EpochWeb.Controllers.BoardController do
  use EpochWeb, :controller

  alias Epoch.Repo
  alias Epoch.Board
  alias EpochWeb.Views.BoardView

  def index(conn, _params) do
    boards = Repo.all(Board)
    conn
    |> put_view(BoardView)
    |> render("index.json", boards: boards)
  end

  def show(conn, %{"id" => id}) do
    case SMF.Helper.enable_smf_fallback? do
      true ->
        board = SMF.Board.find_board(id)
        conn
        |> put_view(BoardView)
        |> render("show.json", board: board)
      _ ->
        text conn, "board id: #{id}"
    end
  end
end