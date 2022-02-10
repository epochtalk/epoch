defmodule EpochLegacyWeb.Controllers.ThreadController do
  use EpochLegacyWeb, :controller
  alias EpochLegacyWeb.Views.ThreadView

  def index(conn, %{"board_id" => board_id, "limit" => limit, "page" => page}) do
    threads = SMF.Topic.find_topic_ids_and_migrate(board_id, limit, page)
    conn
    |> put_view(ThreadView)
    |> render("index.json", threads: threads)
  end

  def show(conn, %{"id" => id}) do
    topic = SMF.Topic.find_topic(id)
    conn
    |> put_view(ThreadView)
    |> render("show.json", topic: topic)
  end
end