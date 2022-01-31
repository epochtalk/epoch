defmodule EpochWeb.Views.PostView do
  use EpochWeb, :view

  def render("index.json", %{posts: posts}) do
    %{
      posts: Enum.map(posts, &post_json/1)
    }
  end

  def post_json(post) do
    %{
      content: post.content,
      thread_id: post.thread_id,
      user_id: post.user_id,
    }
  end
end