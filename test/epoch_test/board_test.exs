defmodule EpochTest.BoardTest do
  use Epoch.DataCase
  import Ecto.Query
  alias Epoch.Board
  alias Epoch.Repo

  doctest Epoch

  setup do
    Repo.delete_all(Board)
    :ok
  end

  test "board" do
    board_created = EpochTest.create_board()
    board_retrieved = from(
      b in Board,
      where: b.id == ^board_created.id
    ) |> Repo.one
    assert board_created.id == board_retrieved.id
    assert board_created.name == board_retrieved.name
    assert board_created.description == board_retrieved.description
  end

  test "boards sql" do
    EpochTest.create_boards()
    {:ok, result} = Repo.query("SELECT * FROM boards")
    boards = Board.from_result(result)
    assert Enum.count(boards) == 3
  end
end
