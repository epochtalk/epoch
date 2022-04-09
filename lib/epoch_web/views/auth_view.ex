defmodule EpochWeb.AuthView do
  use EpochWeb, :view

  def render("search.json", %{found: found}) do
    %{found: found}
  end
end
