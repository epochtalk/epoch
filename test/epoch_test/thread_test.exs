defmodule EpochTest.ThreadTest do 
 use Epoch.DataCase
  doctest Epoch

  test "thread" do
    b = %Epoch.Board{
      name: "Testing Board",
      description: "Testing grounds for discussion",
      created_at: Ecto.DateTime.utc(),
      updated_at: Ecto.DateTime.utc()
    } |> Epoch.Repo.insert!
    t = %Epoch.Thread{
      board: b,
      created_at: Ecto.DateTime.utc(),
      updated_at: Ecto.DateTime.utc()
    } |> Epoch.Repo.insert!
    assert b.id == t.board_id
  end
end
