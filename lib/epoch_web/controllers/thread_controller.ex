defmodule EpochWeb.Controllers.ThreadController do
  use EpochWeb, :controller

  alias Epoch.Repo
  alias Epoch.Thread

  alias EpochWeb.Views.ThreadView

  def index(conn, _params) do
    threads = Repo.all(Thread)
    conn
    |> put_view(ThreadView)
    |> render("index.json", threads: threads)
  end
end