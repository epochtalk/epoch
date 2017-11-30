defmodule Epoch.BoardController do
  use Epoch.Web, :controller
  alias Epoch.Board
  alias Epoch.Category
  import Ecto.Query

  def show(conn, _params) do
    q = from c in Category, preload: [:boards]
    cats = q |> Epoch.Repo.all
    render conn, "show.html", cats: cats
  end
end