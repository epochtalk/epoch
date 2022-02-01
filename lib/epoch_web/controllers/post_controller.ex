defmodule EpochWeb.Controllers.PostController do
  use EpochWeb, :controller

  alias Epoch.Repo
  alias Epoch.Post

  alias EpochWeb.Views.PostView

  def index(conn, %{"thread_id" => thread_id}) do
    case SMF.Helper.enable_smf_fallback? do
      true -> 
        # topic_id = thread_id
        messages = SMF.Message.find_messages(thread_id)
        conn
        |> put_view(PostView)
        |> render("index.json", messages: messages)
      _ ->
        posts = Repo.all(Post)
        conn
        |> put_view(PostView)
        |> render("index.json", posts: posts)
    end
  end

  def show(conn, %{"id" => id}) do
    case SMF.Helper.enable_smf_fallback? do
      true ->
        message = SMF.Message.find_message(id)
        post = SMF.Message.to_post(message)
        conn
        |> put_view(PostView)
        |> render("show.json", post: post)
        # |> render("show.json", message: message)
      _ ->
        text conn, "post id: #{id}"
    end
  end
end