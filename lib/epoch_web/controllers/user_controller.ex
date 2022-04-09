defmodule EpochWeb.UserController do
  use EpochWeb, :controller
  alias Epoch.Repo
  alias Epoch.User

  alias EpochWeb.UserView

  def show(conn, %{"id" => id}) do
    u = Repo.get(User, id)
    conn
    |> put_view(UserView)
    |> render("show.json", user: u)
  end
end
