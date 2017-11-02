defmodule Epoch.MetaController do
  use Epoch.Web, :controller

  def version(conn, _params) do
  	{:ok, vsn} = :application.get_key(:epoch, :vsn)
  	version = vsn |> List.to_string
    conn
    |> json(%{ version: version })
  end
end
