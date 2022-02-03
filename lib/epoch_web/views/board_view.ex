defmodule EpochWeb.Views.BoardView do
  use EpochWeb, :view

  def render("index.json", %{categories_with_boards: categories_with_boards, threads: _threads}) do
    outer_boards_json = categories_with_boards
    |> categories_with_boards_json()

    %{boards: outer_boards_json}
  end

  def render("show.json", %{board: board}) do
    board
  end

  def categories_with_boards_json(categories_with_boards) do
    categories_with_boards |> Enum.map(fn cat ->
      %{
        id: cat.id,
        name: cat.name,
        view_order: cat.view_order,
        viewable_by: cat.viewable_by,
        postable_by: cat.postable_by,
        created_at: cat.created_at,
        imported_at: cat.imported_at,
        updated_at: cat.updated_at,
        meta: cat.meta,
        boards: cat.boards
        |> Enum.map(&board_json/1)
      }
    end)
  end

  def board_json(board) do
    category_id = case Epoch.Repo.all(Ecto.assoc(board, :categories)) do
      [] -> nil
      categories ->
        category = List.first(categories)
        category.id
    end
    %{
      id: board.id,
      name: board.name,
      slug: board.slug,
      description: board.description,
      viewable_by: board.viewable_by,
      postable_by: board.postable_by,
      right_to_left: false,
      disable_post_edit: nil,
      disable_signature: nil,
      disable_selfmod: nil,
      thread_count: 3,
      post_count: 30,
      created_at: "2019-03-27T18:13:53.243Z",
      updated_at: nil,
      imported_at: nil,
      last_thread_id: "FdZRrDErRsqSeOnIRJgGuQ",
      last_thread_slug: "test-breaking-forum-logo",
      parent_id: nil,
      category_id: category_id,
      view_order: 0,
      last_thread_title: "Test Breaking Forum Logo",
      post_deleted: false,
      last_post_created_at: "2020-11-07T11:08:35.311Z",
      last_post_position: 24,
      last_post_username: "jwang",
      last_post_avatar: nil,
      user_id: "WAuHm4JUTeW7UXvud4J1Xg",
      user_deleted: false,
      moderators: nil,
      children: []
    }
  end
end