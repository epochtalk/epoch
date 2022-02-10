defmodule EpochLegacyWeb.Views.PostView do
  use EpochLegacyWeb, :view

  def render("index.json", %{posts: posts}) do
    %{
      posts: Enum.map(posts, &post_json/1)
    }
  end

  def render("index.json", %{messages: messages}) do
    messages
  end

  def render("show.json", %{post: post}) do
    post |> post_json()
  end

  def render("show.json", %{message: message}) do
    message
  end

  def post_json(post) do
    %{
      created_at: post.created_at,
      content: post.content,
      thread_id: post.thread_id,
      user_id: post.user_id,
    }
  end
end