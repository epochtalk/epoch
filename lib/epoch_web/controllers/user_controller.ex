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
        {:ok, user} = Member.migrate(id)
        conn
        |> put_view(UserView)
        |> render("show.json", user: user)
      _ ->
        text conn, "user id: #{id}"
    end
  end
end