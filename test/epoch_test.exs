defmodule EpochTest do
 use Epoch.DataCase
  doctest Epoch

  def create_board(name \\ "Testing Board") do
    %Epoch.Board{
      name: name,
      slug: :crypto.strong_rand_bytes(5) |> Base.url_encode64 |> binary_part(0, 5),
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
      slug: :crypto.strong_rand_bytes(5) |> Base.url_encode64 |> binary_part(0, 5),
      created_at: NaiveDateTime.truncate(NaiveDateTime.utc_now(), :second),
      updated_at: NaiveDateTime.truncate(NaiveDateTime.utc_now(), :second)
    } |> Epoch.Repo.insert!
  end
end
