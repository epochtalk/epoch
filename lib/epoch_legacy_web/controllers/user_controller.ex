defmodule EpochLegacyWeb.Controllers.UserController do
  use EpochWeb, :controller
  alias Epoch.Accounts.User
  alias SMF.Helper
  alias SMF.Member

  alias EpochWeb.Views.UserView

  def show(conn, %{"id" => id}) do
    case Member.migrate(id) do
      {:ok, user} ->
        conn
        |> put_view(UserView)
        |> render("show.json", user: user)
      {:error, _err} ->
        text conn, "error migrating user id: #{id}"
    end
  end
end
