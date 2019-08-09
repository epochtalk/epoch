defmodule EpochTest.PostTest do
 use Epoch.DataCase
  doctest Epoch

  test "post" do
    b = %Epoch.Board{
      name: "Testing Board",
      description: "Testing grounds for discussion",
      created_at: NaiveDateTime.truncate(NaiveDateTime.utc_now(), :second),
      updated_at: NaiveDateTime.truncate(NaiveDateTime.utc_now(), :second)
    } |> Epoch.Repo.insert!
    t = %Epoch.Thread{
      board: b,
      created_at: NaiveDateTime.truncate(NaiveDateTime.utc_now(), :second),
      updated_at: NaiveDateTime.truncate(NaiveDateTime.utc_now(), :second)
    } |> Epoch.Repo.insert!
    assert b.id == t.board_id
    p = %Epoch.Post{
      thread: t,
      created_at: NaiveDateTime.truncate(NaiveDateTime.utc_now(), :second),
      updated_at: NaiveDateTime.truncate(NaiveDateTime.utc_now(), :second)
    } |> Epoch.Repo.insert!
    assert t.id == p.thread_id
  end
end
