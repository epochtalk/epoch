defmodule Epoch.RootController do
  use Epoch.Web, :controller
  alias Epoch.Board

  def index(conn, _params) do
    boards = Board |> Epoch.Repo.all
    render conn, "index.html", boards: boards
  end
end
