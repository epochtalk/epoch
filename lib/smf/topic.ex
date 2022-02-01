defmodule SMF.Topic do
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

  def find_topics(board_id) when is_integer(board_id) and board_id > 0 do
    Epoch.SmfRepo
    |> Ecto.Adapters.SQL.query!(
      """
      SELECT ID_TOPIC, isSticky, ID_BOARD, ID_FIRST_MSG, ID_LAST_MSG,
      ID_MEMBER_STARTED, ID_MEMBER_UPDATED, ID_POLL, numReplies,
      numViews, locked, selfModerated, lastPageChange, bump
      FROM smf_topics
      WHERE ID_BOARD = ?
      ORDER BY ID_TOPIC
      LIMIT 100
      """,
      [board_id])
    |> SMF.Helper.res_to_maps()
  end
end