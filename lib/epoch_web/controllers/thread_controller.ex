defmodule EpochWeb.Controllers.ThreadController do
  use EpochWeb, :controller

  alias Epoch.Repo
  alias Epoch.Thread

  alias EpochWeb.Views.ThreadView

  def index(conn, %{"board_id" => board_id}) do
    case SMF.Helper.enable_smf_fallback? do
      true -> 
        topics = SMF.Topic.find_topics(board_id)
        conn
        |> put_view(ThreadView)
        |> render("index.json", topics: topics)
      _ ->
        threads = Repo.all(Thread)
        conn
        |> put_view(ThreadView)
        |> render("index.json", threads: threads)
    end
  end

  def show(conn, %{"id" => id}) do
    case SMF.Helper.enable_smf_fallback? do
      true ->
        topic = SMF.Topic.find_topic(id)
        conn
        |> put_view(ThreadView)
        |> render("show.json", topic: topic)
      _ ->
        text conn, "thread id: #{id}"
    end
  end
end