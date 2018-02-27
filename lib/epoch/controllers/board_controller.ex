defmodule Epoch.BoardController do
  use Epoch.Web, :controller
  alias Epoch.Board
  alias Epoch.Thread
  alias Epoch.Repo

  import Ecto.Query

  def show(conn, %{"id" => id} = params) do
    board_query =
      from(
        b in Board,
        where: b.id == ^id
      )
    board = board_query |> Repo.one

    threads_query =
      from(
        from t in Thread, preload: [:posts],
        where: t.board_id == ^id,
        order_by: [desc: t.created_at],
        limit: 10
      )
    threads = threads_query |> Repo.all
    threads |> hd |> Map.get(:posts) |> hd |> IO.inspect

    render conn, "show.html", board: board, threads: threads
  end
end
