defmodule EpochWeb.AuthErrorHandler do
  import Plug.Conn
  alias EpochWeb.ErrorView

  @behaviour Guardian.Plug.ErrorHandler

  @impl Guardian.Plug.ErrorHandler
  def auth_error(conn, {type, reason}, opts) do
    IO.puts("Auth error:")
    IO.inspect(type)
    IO.inspect(reason)
    conn
    # |> put_view(ErrorView)
    # |> render("401.json", %{message: inspect({type, reason})})
    # |> render("401.json", %{message: inspect(changeset.errors)})
    |> put_resp_content_type("text/plain")
    |> send_resp(401, inspect({type, reason}))
  end
end
