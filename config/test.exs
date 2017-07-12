use Mix.Config

# Configure your database
config :epoch, Epoch.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "epoch_dev",
  hostname: "localhost",
  pool_size: 10
