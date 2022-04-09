defmodule EpochWeb.ThreadView do
  use EpochWeb, :view

  def render("index.json", %{threads: threads}) do
    %{
      threads: Enum.map(threads, &thread_json/1)
    }
  end

  def render("index.json", %{topics: topics}) do
    topics
  end

  def render("show.json", %{topic: topic}) do
    topic
  end

  def thread_json(thread) do
    %{
      board_id: thread.board_id
    }
  end
end
