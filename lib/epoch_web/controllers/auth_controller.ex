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
  def email(conn, %{"email" => email}) do
    email_taken = email
    |> User.with_email_exists?

    respond_ok(%{ found: email_taken }, conn)
  end
  def register(conn, attrs) do
    IO.puts("registering")
    IO.inspect(attrs)
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
    |> case do
      {:ok, user} ->
        %{
          token: user.confirmation_token,
          id: user.id,
          username: user.username,
          # TODO(boka): fill in these fields
          avatar: "", # user.avatar
          permissions: %{}, # user.permissions
          roles: %{} # user.roles
        }
        |> respond_ok(conn)
      # TODO(boka): handle errors
      {:error, error} ->
        respond_ok(error, conn)
    end
  end
end
