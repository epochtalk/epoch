defmodule EpochWeb.ErrorView do
  use EpochWeb, :view

  def render("400.json", %{conn: conn}) do
    %{message: conn.assigns.reason.message}
  end

  # By default, Phoenix returns the status message from
  # the template name. For example, "404.json" becomes
  # "Not Found".
  def template_not_found(template, _assigns) do
    %{message: Phoenix.Controller.status_message_from_template(template)}
  end
end
