import Config

# General application configuration
config :epoch,
  ecto_repos: [Epoch.Repo]

# Configures the endpoint
config :epoch, Epoch.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "bPUDZDgqoq2Z695JPHMZRWgHw7brgWv7IquLoyATDl5DFKDLkol0jD5oAOFT+uhb"
  # render_errors: [view: Epoch.ErrorView, accepts: ~w(html json)],
  # pubsub: [name: Epoch.PubSub,
  #          adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
