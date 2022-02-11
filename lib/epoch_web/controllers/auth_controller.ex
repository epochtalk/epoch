defmodule EpochWeb.Controllers.AuthController do
  use EpochWeb, :controller

  def username(conn, %{"username" => username}) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, """
    {"found": false}
    """)
  end
end
