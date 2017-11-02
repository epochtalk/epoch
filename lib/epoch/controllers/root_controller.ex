defmodule Epoch.RootController do
  use Epoch.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
