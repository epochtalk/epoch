defmodule EpochWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :epoch

  # The session will be stored in the cookie and signed,
  # this means its contents can be read but not tampered with.
  # Set :encryption_salt if you would also like to encrypt it.
  # Generate salt:  mix phx.gen.secret 32
  @session_options [
    store: :cookie,
    key: "_epoch_key",
    signing_salt: "xt5Mn4WjOYETgmQKYdXGG2dtUen3Yj55"
  ]

  plug Corsica, origins: "*", allow_headers: :all
  plug Plug.RequestId
  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Phoenix.json_library()

  plug Plug.MethodOverride
  plug Plug.Head
  plug Plug.Session, @session_options
  plug EpochWeb.Router
end
