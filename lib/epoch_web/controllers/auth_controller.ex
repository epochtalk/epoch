defmodule EpochWeb.Controllers.AuthController do
  use EpochWeb, :controller
  alias Epoch.User

  def respond_ok(data, conn) do
    Jason.encode(data)
    |> case do
      {:ok, encoded_data} ->
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(200, encoded_data)
      _ ->
        IO.puts("uh oh...")
    end
  end
  def username(conn, %{"username" => username}) do
    username_taken = username
    |> User.with_username_exists?

    respond_ok(%{ found: username_taken }, conn)
  end
end
