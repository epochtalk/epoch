defmodule EpochWeb.AuthController do
  use EpochWeb, :controller
  alias Epoch.User
  alias Epoch.Repo

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
    username_found = username
    |> User.with_username_exists?

    render(conn, "search.json", found: username_found)
  end
  def email(conn, %{"email" => email}) do
    email_found = email
    |> User.with_email_exists?

    render(conn, "search.json", found: email_found)
  end
  def register(conn, attrs) do
    IO.puts("registering")
    IO.inspect(attrs)
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
    |> case do
      {:ok, user} ->
        conn
        |> render("show.json", user: user)
      # TODO(boka): handle errors
      {:error, error} ->
        respond_ok(error, conn)
    end
  end
end
