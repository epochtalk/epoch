defmodule EpochWeb.BoardController do
  use EpochWeb, :controller
  alias Epoch.Category
  alias Epoch.Repo
  alias EpochWeb.BoardView

  def index(conn, _params) do
    categories_with_boards = Category
    |> Repo.all()
    |> Repo.preload(:boards)

    conn
    |> put_view(BoardView)
    |> render("index.json", categories_with_boards: categories_with_boards, threads: [])
  end

  def show(conn, %{"id" => id}) do
    text conn, "board id: #{id}"
  end

  def id(conn, %{"slug" => _slug}) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, """
    {"id": 2}
    """)
  end
end
