defmodule EpochWeb.Controllers.PostController do
  use EpochWeb, :controller
  alias Epoch.Repo
  alias Epoch.Post
  alias EpochWeb.Views.PostView

  def index(conn, %{"thread_id" => thread_id}) do
    posts = case SMF.Helper.enable_smf_fallback? do
      true -> 
        # topic_id = thread_id
        messages = SMF.Message.find_messages(thread_id)
        posts = messages
        |> Enum.map(fn message ->
          SMF.Message.to_post_attrs(message)
        end)
        posts
      _ ->
        posts = Repo.all(Post)
        posts
    end
    conn
    |> put_view(PostView)
    |> render("index.json", posts: posts)
  end

  def show(conn, %{"id" => id}) do
    case SMF.Helper.enable_smf_fallback? do
      true ->
        case SMF.Message.migrate(id) do
          {:ok, post} ->
            conn
            |> put_view(PostView)
            |> render("show.json", post: post)
          {:error, _err} ->
            text conn, "post id: #{id} not found"
        end
      _ ->
        text conn, "post id: #{id}"
    end
  end
end