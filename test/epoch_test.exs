defmodule EpochTest do 
 use Epoch.DataCase
  doctest Epoch

  def create_board(name \\ "Testing Board") do
    %Epoch.Board{
      name: name,
      description: "Testing grounds for discussion",
      created_at: NaiveDateTime.utc_now(),
      updated_at: NaiveDateTime.utc_now(),
      post_count: 0,
      thread_count: 0
    } |> Epoch.Repo.insert!
  end

  def create_boards(count \\ 3) do
    Enum.each(1..count, &(create_board("Testing Board #{&1}")))
  end
end
