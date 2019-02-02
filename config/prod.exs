use Mix.Config

# Configure your database
config :epoch, Epoch.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "epoch",
  hostname: "localhost",
  pool_size: 10

config :epoch, Epoch.Endpoint,
  http: [port: 4000],
  debug_errors: true,
  check_origin: false


if File.exists?("config/prod.secret.exs") do
  import_config "prod.secret.exs"
end
