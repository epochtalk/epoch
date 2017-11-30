defmodule Epoch.RootController do
  use Epoch.Web, :controller
  alias Epoch.Board
  alias Epoch.Category
  import Ecto.Query

  def index(conn, _params) do
    sql = """
    SELECT b.name
    FROM categories c, boards b, board_mapping m
    WHERE b.id = m.board_id
    AND c.id = m.category_id
    AND m.category_id IS NOT NULL
    """

    q = from c in Category, preload: [:boards]
    cats = q |> Epoch.Repo.all
    render conn, "index.html", cats: cats
  end
end