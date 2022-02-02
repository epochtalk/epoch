defmodule SMF.Board do
  alias Epoch.Repo

  def migrate(id) do
    case find_board(id) do
      nil -> nil
      smf_board ->
        board_attrs = to_board_attrs(smf_board)
        case board_attrs do
          nil -> {:error, "board not found"}
          _ ->
            %Epoch.Board{}
            |> Epoch.Board.changeset(board_attrs)
            |> Repo.insert(conflict_target: :id, on_conflict: :replace_all)
        end 
    end
  end

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
      SELECT ID_BOARD, ID_CAT, childLevel, ID_PARENT, boardOrder,
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

  def to_board_attrs(board) do
    %{
      id: board["ID_BOARD"],
      description: board["description"],
      name: board["name"],
      post_count: board["numPosts"],
      slug: "slug-#{board["ID_BOARD"]}",
      thread_count: board["numTopics"]
    }
  end
end