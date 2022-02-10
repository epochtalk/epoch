defmodule EpochLegacyWeb.Controllers.RootController do
  use EpochLegacyWeb, :controller
  
  def motd(conn, _params) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, """
    {
      "motd": "Running version [url=https://github.com/epochtalk/epochtalk/commits/44EDD202]44EDD202[/url]",
      "motd_html": "Running version <a href=\\"https://github.com/epochtalk/epochtalk/commits/44EDD202\\" target=\\"_blank\\">44EDD202</a>",
      "main_view_only": true
    }
    """)
  end
end