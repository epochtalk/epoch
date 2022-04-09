defmodule EpochWeb.UserView do
  use EpochWeb, :view

  def render("show.json", %{user: user}) do
    user |> user_json()
  end

  def render("show.json", %{member: member}) do
    member
  end

  def user_json(user) do
    %{
      id: user.id,
      email: user.email,
      username: user.username,
      created_at: user.created_at,
      updated_at: user.updated_at
    }
  end
end
