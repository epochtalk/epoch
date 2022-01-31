defmodule EpochWeb.Views.ThreadView do
  use EpochWeb, :view

  def render("index.json", %{threads: threads}) do
    %{
      threads: Enum.map(threads, &thread_json/1)
    }
  end

  def thread_json(thread) do
    %{
      board_id: thread.board_id
    }
  end
end