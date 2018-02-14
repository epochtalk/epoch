defmodule Epoch.RootController do
  use Epoch.Web, :controller
  alias Epoch.Board
  alias Epoch.Category
  import Ecto.Query

  def index(conn, _params) do
    q = from c in Category, preload: [:boards]
    cats = q |> Epoch.Repo.all
    render conn, "index.html", cats: cats
  end
end