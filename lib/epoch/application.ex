defmodule Epoch.Application do
  use Application
  def start(_type, _args) do
    children = [
      Epoch.Repo,
      EpochWeb.Endpoint
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Epoch.Supervisor]
    Supervisor.start_link(children, opts)
  end
end