defmodule EpochTest.ThreadTest do 
 use Epoch.DataCase
  import Ecto.Query
  alias Epoch.Thread
  alias Epoch.Repo
  doctest Epoch

  test "thread" do
    thread_created = EpochTest.create_thread()
    thread_retrieved = from(
      t in Thread,
      where: t.id == ^thread_created.id,
      preload: [:board]
    ) |> Repo.one
    assert thread_created.id == thread_retrieved.id
  end
end
