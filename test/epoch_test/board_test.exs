defmodule EpochTest.BoardTest do 
  use Epoch.DataCase
  import Ecto.Query
  alias Epoch.Board
  alias Epoch.Repo

  doctest Epoch

  test "board" do
    board_created = EpochTest.create_board
    board_retrieved = from(
      b in Board,
      where: b.id == ^board_created.id
    ) |> Epoch.Repo.one
    
    assert board_created.name == board_retrieved.name
    assert board_created == board_retrieved

  end

  test "boards sql" do
    EpochTest.create_boards()
    {:ok, result} = Epoch.Repo.query("SELECT * FROM boards")
    boards = Epoch.Board.from_result(result)
    assert Enum.count(boards) == 3
  end
end
