defmodule EpochWeb.Controllers.AuthController do
  use EpochWeb, :controller
  alias Epoch.User

  def username(conn, %{"username" => username}) do
    username_taken = username
    |> User.with_username_exists?

    IO.puts(username_taken)

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, """
    {"found": false}
    """)
  end
end
