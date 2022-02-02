defmodule EpochWeb.Controllers.BoardController do
  use EpochWeb, :controller

  alias Epoch.Repo
  alias Epoch.Board
  alias EpochWeb.Views.BoardView

  def index(conn, _params) do
    boards = Repo.all(Board)
    conn
    |> put_resp_content_type("application/json")
    |> text("""
    {"boards":[{"id":"rXAgL_IlScCG4I7XGitm4A","name":"General","view_order":0,"viewable_by":null,"postable_by":null,"created_at":null,"imported_at":null,"updated_at":null,"meta":null,"boards":[{"id":"YRSOa4ILQY6VAYlUArp_xg","name":"General Discussion Board","slug":"61148e6b-820b-418e-9501-895402ba7fc6","description":"Say Hello","viewable_by":null,"postable_by":null,"right_to_left":false,"disable_post_edit":null,"disable_signature":null,"disable_selfmod":null,"thread_count":2,"post_count":3,"created_at":"2019-10-04T02:07:17.545Z","updated_at":null,"imported_at":null,"last_thread_id":"JXyBh9D6SbeMbSCi30TQow","last_thread_slug":"257c8187-d0fa-49b7-8c6d-20a2df44d0a3","parent_id":null,"category_id":"rXAgL_IlScCG4I7XGitm4A","view_order":0,"last_thread_title":"A poll","post_deleted":false,"last_post_created_at":"2020-01-31T19:40:56.655Z","last_post_position":2,"last_post_username":"wangbus","last_post_avatar":null,"user_id":"hY1JXkXfTziN68fViHC6ng","user_deleted":false,"moderators":null,"children":[]}]}],"threads":[{"id":"JXyBh9D6SbeMbSCi30TQow","slug":"257c8187-d0fa-49b7-8c6d-20a2df44d0a3","locked":false,"sticky":false,"moderated":false,"poll":true,"updated_at":"2020-01-31T19:40:56.655Z","view_count":3,"title":"A poll","board":{"id":"YRSOa4ILQY6VAYlUArp_xg","name":"General Discussion Board","slug":"61148e6b-820b-418e-9501-895402ba7fc6"},"post":{"id":"Ey5RDeGySpWgwGCcShpGJQ","position":2,"created_at":"2020-01-31T19:40:56.655Z","deleted":false},"user":{"id":"hY1JXkXfTziN68fViHC6ng","username":"wangbus","deleted":false}},{"id":"gduqrG9FSFesejwNytn4YQ","slug":"81dbaaac-6f45-4857-ac7a-3c0dcad9f861","locked":false,"sticky":false,"moderated":false,"poll":false,"updated_at":"2019-10-04T02:07:29.489Z","view_count":2,"title":"Say Hello","board":{"id":"YRSOa4ILQY6VAYlUArp_xg","name":"General Discussion Board","slug":"61148e6b-820b-418e-9501-895402ba7fc6"},"post":{"id":"5NW1AwaeQhqnp4he_EV9OA","position":1,"created_at":"2019-10-04T02:07:29.489Z","deleted":false},"user":{"id":"O4EC0czaRzGTHGjOJW3fBA","username":"boka","deleted":false}}]}
    """)
    # conn
    # |> put_view(BoardView)
    # |> render("index.json", boards: boards)
  end

  def show(conn, %{"id" => id}) do
    case SMF.Helper.enable_smf_fallback? do
      true ->
        board = SMF.Board.find_board(id)
        conn
        |> put_view(BoardView)
        |> render("show.json", board: board)
      _ ->
        text conn, "board id: #{id}"
    end
  end
end