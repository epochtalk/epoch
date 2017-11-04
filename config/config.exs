# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

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

config :phoenix, :template_engines,
  slim: PhoenixSlime.Engine,
  slime: PhoenixSlime.Engine
  
config :phoenix_slime, :use_slim_extension, true

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
