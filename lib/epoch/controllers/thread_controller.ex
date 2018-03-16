defmodule Epoch.ThreadController do
  use Epoch.Web, :controller
  # alias Epoch.Board
  alias Epoch.Thread
  alias Epoch.Repo

  import Ecto.Query

  def index(conn, %{"board_id" => board_id}) do
    threads_query =
      from(
        from t in Thread, preload: [:posts],
        where: t.board_id == ^board_id,
        order_by: [desc: t.created_at],
        limit: 10
      )
    threads = threads_query |> Repo.all
    render conn, "index.html", threads: threads
  end
end
