defmodule EpochWeb.AuthView do
  use EpochWeb, :view

  def render("search.json", %{found: found}) do
    %{found: found}
  end
  def render("show.json", %{user: user}) do
    user |> user_json()
  end
  def user_json(user) do
    %{
      id: user.id,
      username: user.username,
          # TODO(boka): fill in these fields
      avatar: "", # user.avatar
      permissions: %{}, # user.permissions
      roles: %{} # user.roles
    }
  end
end
