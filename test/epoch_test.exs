defmodule EpochTest do
  use ExUnit.Case
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

  test "post" do
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
    p = %Epoch.Post{
      thread: t,
      created_at: Ecto.DateTime.utc(),
      updated_at: Ecto.DateTime.utc()
    } |> Epoch.Repo.insert!
    assert t.id == p.thread_id
  end
end
