defmodule EpochWeb.AuthController do
  use EpochWeb, :controller
  alias Epoch.User
  alias Epoch.Repo

  alias EpochWeb.ErrorView

  @rand_size 32

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
  def login(conn, %{"username" => username, "password" => password, "rememberMe" => remember_me} = user_params) do
    # TODO: check if logged in


    if user = User.by_username_and_password(username, password) do
      # TODO: check confirmation token
      # TODO: check ban expiration
      # TODO: get moderated boards
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
  defp log_in_user(conn, user, %{"rememberMe" => remember_me} \\ %{}) do
    datetime = NaiveDateTime.utc_now
    session_id = UUID.uuid1()
    decoded_token = %{ user_id: user.id, session_id: session_id, timestamp: datetime }

    {:ok, token, _claims} = case remember_me do
      "true" ->
        # set longer expiration
        Epoch.Guardian.encode_and_sign(decoded_token, %{}, ttl: {4, :weeks})
      _ ->
        # set default expiration
        Epoch.Guardian.encode_and_sign(decoded_token, %{}, ttl: {1, :day})
    end
    Epoch.Guardian.decode_and_verify(token)
    |> IO.inspect()
    session_key = "user:#{user.id}:session:#{token}"
    Redix.command(:redix, ["SET", session_key, decoded_token.timestamp])
    |> IO.inspect
    Redix.command(:redix, ["GET", session_key])
    |> IO.inspect

    # save session
    user_key = "user:#{user.id}"

    Redix.command(:redix, ["HSET", user_key, "username", user.username])
    # check for avatar first and use it if it's there
    # Redix.command(:redix, ["HSET", user_key, "username", user.username, "avatar", user.id])
    |> IO.inspect
    Redix.command(:redix, ["HGETALL", user_key])
    |> IO.inspect

    user = Map.put(user, :token, token)

    # TODO: check for empty roles first
    # add default role
    user = Map.put(user, :roles, ["user"])

    conn
    |> render("credentials.json", user: user)
  end
end
