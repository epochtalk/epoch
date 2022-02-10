defmodule Epoch.Application do
  use Application
  def start(_type, _args) do
    children = epoch_otp_apps()
    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Epoch.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defp epoch_otp_apps() do
    children = [
      Epoch.Repo,
    ]
    case SMF.Helper.enable_smf_fallback? do
      true -> 
        [Epoch.SmfRepo, EpochLegacyWeb.Endpoint] ++ children
      _ ->
        [EpochWeb.Endpoint|children]
    end
  end
end