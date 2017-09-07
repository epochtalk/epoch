defmodule Epoch.RootController do
  use Epoch.Web, :controller

  def index(conn, _params) do
    conn
    |> json(%{ message: "indexes" })
  end
end
