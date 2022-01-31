defmodule EpochWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :epoch

  plug Plug.RequestId
  plug Plug.Logger
  plug Epoch.Api
end
