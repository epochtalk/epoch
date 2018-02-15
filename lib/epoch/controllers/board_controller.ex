defmodule Epoch.BoardController do
  use Epoch.Web, :controller
  alias Epoch.Board
  alias Epoch.Category
  alias Epoch.Thread
  alias Epoch.Post

  import Ecto.Query

  def show(conn, %{"id" => id} = params) do
    board_query =
      from(
        b in Board,
        where: b.id == ^id
      )
    board = board_query |> Epoch.Repo.one

    threads_query =
      from(
        from t in Thread, preload: [:posts],
        where: t.board_id == ^id,
        order_by: [desc: t.created_at],
        limit: 10
      )
    threads = threads_query |> Epoch.Repo.all

    threads |> hd |> Map.get(:posts) |> hd |> IO.inspect

    render conn, "show.html", board: board, threads: threads
  end
end