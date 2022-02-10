defmodule EpochWeb.Controllers.ThreadController do
  use EpochWeb, :controller

  alias Epoch.Repo
  alias Epoch.Thread

  alias EpochWeb.Views.ThreadView

  def index(conn, %{"board_id" => _board_id, "limit" => _limit, "page" => _page}) do
    threads = Repo.all(Thread)
    conn
    |> put_view(ThreadView)
    |> render("index.json", threads: threads)
  end

  def show(conn, %{"id" => id}) do
    text conn, "thread id: #{id}"
  end
end