defmodule EpochWeb.PostController do
  use EpochWeb, :controller
  alias Epoch.Repo
  alias Epoch.Post
  alias EpochWeb.PostView

  def index(conn, %{"thread_id" => thread_id}) do
    posts = Repo.all(Post)
    conn
    |> put_view(PostView)
    |> render("index.json", posts: posts)
  end

  def show(conn, %{"id" => id}) do
    text conn, "post id: #{id}"
  end
end
