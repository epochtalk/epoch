import Config

# General application configuration
config :epoch,
  ecto_repos: [Epoch.Repo]

# Configures the endpoint
config :epoch, EpochWeb.Endpoint,
  url: [host: "localhost"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
