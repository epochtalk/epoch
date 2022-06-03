defmodule EpochWeb.ErrorView do
  use EpochWeb, :view

  # If you want to customize a particular status code
  # for a certain format, you may uncomment below.
  # def render("500.json", _assigns) do
  #   %{errors: %{detail: "Internal Server Error"}}
  # end

  # By default, Phoenix returns the status message from
  # the template name. For example, "404.json" becomes
  # "Not Found".
  def render("400.json", %{conn: conn}) do
    %{message: conn.assigns.reason.message}
  end
  def template_not_found(template, _assigns) do
    # %{errors: %{detail: Phoenix.Controller.status_message_from_template(template)}}
    %{message: Phoenix.Controller.status_message_from_template(template)}
  end
end
