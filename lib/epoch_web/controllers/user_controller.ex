defmodule EpochWeb.Controllers.UserController do
  use EpochWeb, :controller
  alias Epoch.Repo
  alias Epoch.User

  alias SMF.Helper
  alias SMF.Member

  alias EpochWeb.Views.UserView

  def show(conn, %{"id" => id}) do
    case Helper.enable_smf_fallback? do
      true ->
        case Member.migrate(id) do
          {:ok, user} ->
            conn
            |> put_view(UserView)
            |> render("show.json", user: user)
          {:error, _err} ->
            text conn, "error migrating user id: #{id}"
        end
      _ ->
        u = Repo.get(User, id)
        conn
        |> put_view(UserView)
        |> render("show.json", user: u)
    end
  end
end