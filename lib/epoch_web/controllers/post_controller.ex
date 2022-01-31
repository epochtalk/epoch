defmodule EpochWeb.Controllers.PostController do
  use EpochWeb, :controller

  alias Epoch.Repo
  alias Epoch.Post

  alias EpochWeb.Views.PostView

  def index(conn, _params) do
    posts = Repo.all(Post)
    conn
    |> put_view(PostView)
    |> render("index.json", posts: posts)
  end
end