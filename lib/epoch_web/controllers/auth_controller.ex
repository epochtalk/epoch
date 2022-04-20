defmodule EpochWeb.AuthController do
  use EpochWeb, :controller
  alias Epoch.User
  alias Epoch.Repo

  alias EpochWeb.ErrorView

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
    %User{}
    |> User.registration_changeset(attrs)
    |> Repo.insert()
    |> case do
      {:ok, user} ->
        conn
        |> render("show.json", user: user)
      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_view(ErrorView)
        |> render("400.json", %{message: inspect(changeset.errors)})
    end
  end
  def login(conn, %{"user" => user_params}) do
    %{"username" => username, "password" => password} = user_params
    # TODO: check if logged in

    # TODO: check user with password exists
    if user = User.by_username_and_password(username, password) do
      # TODO: check confirmation token
      # TODO: check passhash exists
      # TODO: check passhash matches
      # TODO: check ban expiration
      # TODO: get moderated boards
      # TODO: set session expiration
      # TODO: build token, save session
      log_in_user(conn, user, user_params)
    else
      # TODO: Don't really need this if only checking usernames
      #       With username search, enumeration is not applicable
      # In order to prevent user enumeration attacks, don't disclose whether the [originally email] username is registered.
      conn
      |> put_view(ErrorView)
      |> render("400.json", %{message: "Invalid username or password"})
    end
  end
  defp log_in_user(conn, user, params \\ %{}) do
    # TODO: clean up commented code when functionality is implemented
    token = user.username # Accounts.generate_user_session_token(user)
    # user_return_to = get_session(conn, :user_return_to)
    user = Map.put(user, :token, token)

    conn
    # |> renew_session()
    # |> put_session(:user_token, token)
    # |> put_session(:live_socket_id, "users_sessions:#{Base.url_encode64(token)}")
    # |> maybe_write_remember_me_cookie(token, params)
    # |> redirect(to: user_return_to || signed_in_path(conn))
    |> render("credentials.json", user: user)
  end
end
