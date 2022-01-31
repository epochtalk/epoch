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
end