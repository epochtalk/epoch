defmodule EpochWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :epoch

  plug Corsica, origins: "*", allow_headers: :all
  plug Plug.RequestId
  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Phoenix.json_library()

  plug Plug.MethodOverride
  plug Plug.Head
  plug EpochWeb.Router
end