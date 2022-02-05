defmodule EpochWeb.Controllers.ThreadController do
  use EpochWeb, :controller

  alias Epoch.Repo
  alias Epoch.Thread

  alias EpochWeb.Views.ThreadView

  def index(conn, %{"board_id" => board_id, "limit" => limit, "page" => page}) do
    threads = case SMF.Helper.enable_smf_fallback? do
      true -> SMF.Topic.find_topic_ids_and_migrate(board_id, limit, page)
      _ -> Repo.all(Thread)
    end
    conn
    |> put_view(ThreadView)
    |> render("index.json", threads: threads)
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