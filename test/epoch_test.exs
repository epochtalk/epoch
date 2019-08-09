defmodule EpochTest do
 use Epoch.DataCase
  doctest Epoch

  def create_board(name \\ "Testing Board") do
    %Epoch.Board{
      name: name,
      description: "Testing grounds for discussion",
      created_at: NaiveDateTime.truncate(NaiveDateTime.utc_now(), :second),
      updated_at: NaiveDateTime.truncate(NaiveDateTime.utc_now(), :second)
    } |> Epoch.Repo.insert!
  end

  def create_boards(count \\ 3) do
    Enum.each(1..count, &(create_board("Testing Board #{&1}")))
  end

  def create_thread(board \\ create_board()) do
    %Epoch.Thread{
      board: board,
      created_at: NaiveDateTime.truncate(NaiveDateTime.utc_now(), :second),
      updated_at: NaiveDateTime.truncate(NaiveDateTime.utc_now(), :second)
    } |> Epoch.Repo.insert!
  end
end
