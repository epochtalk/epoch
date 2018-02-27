defmodule EpochTest do 
 use Epoch.DataCase
  doctest Epoch

  def create_board(name \\ "Testing Board") do
    %Epoch.Board{
      name: name,
      description: "Testing grounds for discussion",
      created_at: Ecto.DateTime.utc(),
      updated_at: Ecto.DateTime.utc()
    } |> Epoch.Repo.insert!
  end

  def create_boards(count \\ 3) do
    Enum.each(1..count, &(create_board("Testing Board #{&1}")))
  end
end
