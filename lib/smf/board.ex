defmodule SMF.Board do
  def find_boards() do
    Epoch.SmfRepo
    |> Ecto.Adapters.SQL.query!(
      """
      SELECT ID_BOARD ID_CAT, childLevel, ID_PARENT, boardOrder,
      ID_LAST_MSG, ID_MSG_UPDATED, memberGroups, name, description,
      numTopics, numPosts, countPosts, ID_THEME, permission_mode,
      override_theme, allowIgnore, lang
      FROM smf_boards
      """)
    |> SMF.Helper.res_to_maps()
  end

  def find_board(id) when is_binary(id) do
    String.to_integer(id)
    |> find_board()
  end

  def find_board(id) when is_integer(id) and id > 0 do
    Epoch.SmfRepo
    |> Ecto.Adapters.SQL.query!(
      """
      SELECT ID_BOARD ID_CAT, childLevel, ID_PARENT, boardOrder,
      ID_LAST_MSG, ID_MSG_UPDATED, memberGroups, name, description,
      numTopics, numPosts, countPosts, ID_THEME, permission_mode,
      override_theme, allowIgnore, lang
      FROM smf_boards
      WHERE ID_BOARD = ?
      """,
      [id])
    |> SMF.Helper.res_to_maps()
    |> List.first()
  end
end