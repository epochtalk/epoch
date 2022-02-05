defmodule SMF.Topic do
  alias Epoch.Repo
  alias Epoch.Thread

  def migrate(id) do
    thread_attrs = id
    |> find_topic()
    |> to_thread_attrs()
    case thread_attrs do
      nil -> {:error, "thread not found"}
      _ ->
        SMF.Board.migrate(thread_attrs.board_id)
        %Thread{}
        |> Thread.changeset(thread_attrs)
        |> Repo.insert(conflict_target: :id, on_conflict: :replace_all)
    end 
  end

  def find_topic(id) when is_binary(id) do
    String.to_integer(id)
    |> find_topic()
  end

  def find_topic(id) when is_integer(id) and id > 0 do
    Epoch.SmfRepo
    |> Ecto.Adapters.SQL.query!(
      """
      SELECT ID_TOPIC, isSticky, ID_BOARD, ID_FIRST_MSG, ID_LAST_MSG,
      ID_MEMBER_STARTED, ID_MEMBER_UPDATED, ID_POLL, numReplies,
      numViews, locked, selfModerated, lastPageChange, bump
      FROM smf_topics
      WHERE ID_TOPIC = ?
      LIMIT 1
      """,
      [id])
    |> SMF.Helper.res_to_maps()
    |> List.first()
  end

  def find_topics(board_id) when is_binary(board_id) do
    String.to_integer(board_id)
    |> find_topics()
  end

  def find_topics_as_threads(board_id, limit \\ 25, page \\ 1) do
    board_id = String.to_integer(board_id)
    find_topics(board_id, limit, page)
  end

  def find_topic_ids_and_migrate(board_id, limit \\ 25, page \\ 1) do
    {:ok, topic_ids} = find_topic_ids(board_id, limit, page)
    topic_ids
    |> Enum.map(fn topic_id ->
      migrate(topic_id)
    end)
  end

  def find_topic_ids(board_id, limit, page) do
    case Epoch.SmfRepo
    |> Ecto.Adapters.SQL.query(
      """
      SELECT ID_TOPIC
      FROM smf_topics
      WHERE ID_BOARD = ?
      ORDER BY ID_TOPIC
      LIMIT #{limit}
      """,
      [board_id]) do
      {:ok, res} ->
        ids = res.rows |> Enum.map(fn row -> List.first(row) end)
        {:ok, ids}
    end
  end

  def find_topics(board_id, limit, page)
  when is_binary(board_id) and is_binary(limit) and is_binary(page) do
    find_topics(String.to_integer(board_id), String.to_integer(limit), String.to_integer(page))
  end

  def find_topics(board_id, limit, page)
  when is_integer(board_id) and is_integer(limit) and is_integer(page)
  and board_id > 0 and limit > 0 and page > 0 do
    Epoch.SmfRepo
    |> Ecto.Adapters.SQL.query!(
      """
      SELECT ID_TOPIC, isSticky, ID_BOARD, ID_FIRST_MSG, ID_LAST_MSG,
      ID_MEMBER_STARTED, ID_MEMBER_UPDATED, ID_POLL, numReplies,
      numViews, locked, selfModerated, lastPageChange, bump
      FROM smf_topics
      WHERE ID_BOARD = ?
      ORDER BY ID_TOPIC
      LIMIT #{limit}
      """,
      [board_id])
    |> SMF.Helper.res_to_maps()
  end

  def to_thread_attrs(topic) do
    %{
      id: topic["ID_TOPIC"],
      board_id: topic["ID_BOARD"],
      locked: topic["locked"],
      post_count: topic["numReplies"],
      slug: "slug-#{topic["ID_TOPIC"]}",
      sticky: topic["isSticky"],
      smf_topic: topic
    }
  end
end