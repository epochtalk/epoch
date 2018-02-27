defmodule EpochTest.BoardTest do 
 use Epoch.DataCase
  doctest Epoch

  test "board" do
    b = %Epoch.Board{
      name: "Testing Board",
      description: "Testing grounds for discussion",
      created_at: Ecto.DateTime.utc(),
      updated_at: Ecto.DateTime.utc()
    } |> Epoch.Repo.insert!
    assert b.name == "Testing Board"
  end

  test "boards sql" do
    EpochTest.create_boards()
    {:ok, result} = Epoch.Repo.query("SELECT * FROM boards")
    boards = Epoch.Board.from_result(result)
    assert Enum.count(boards) == 3
  end
end
