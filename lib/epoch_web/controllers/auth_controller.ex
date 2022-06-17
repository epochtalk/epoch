defmodule EpochWeb.AuthController do
  use EpochWeb, :controller
  alias Epoch.User
  alias Epoch.Repo
  alias Epoch.Guardian

  alias EpochWeb.CustomErrors.{InvalidCredentials}
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
  def logout(conn, params) do
    if Guardian.Plug.authenticated?(conn) do
      Guardian.Plug.current_token(conn)
      |> Guardian.revoke
      render(conn, "logout.json")
    end
  end
  def login(conn, user_params) when not is_map_key(user_params, "rememberMe") do
    login(conn, Map.put(user_params, "rememberMe", false))
  end
  def login(conn, %{"username" => username, "password" => password} = user_params) do
    # TODO: check if logged in
    if Guardian.Plug.authenticated?(conn) do
      IO.puts("already logged in")
      user = Guardian.Plug.current_resource(conn)
    else
      if user = User.by_username_and_password(username, password) do
        # TODO: check confirmation token
        # TODO: check ban expiration
        # TODO: get moderated boards
        log_in_user(conn, user, user_params)
      else
        raise(InvalidCredentials)
      end
    end
  end
  defp log_in_user(conn, user, %{"rememberMe" => remember_me}) do
    datetime = NaiveDateTime.utc_now
    session_id = UUID.uuid1()
    decoded_token = %{ user_id: user.id, session_id: session_id, timestamp: datetime }

    {:ok, token, _claims} = case remember_me do
      "true" ->
        # set longer expiration
        Guardian.encode_and_sign(decoded_token, %{}, ttl: {4, :weeks})
      _ ->
        # set default expiration
        Guardian.encode_and_sign(decoded_token, %{}, ttl: {1, :day})
    end

    user = Map.put(user, :token, token)

    # TODO: check for empty roles first
    # add default role
    user = Map.put(user, :roles, ["user"])

    conn
    |> render("credentials.json", user: user)
  end
end
