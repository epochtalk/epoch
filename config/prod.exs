import Config

# Configure your database
config :epoch, Epoch.Repo,
  username: "postgres",
  password: "postgres",
  database: "epoch",
  hostname: "localhost",
  pool_size: 10,
  port: "5432"

config :epoch, Epoch.Endpoint,
  http: [port: 4000],
  debug_errors: true,
  check_origin: false


if File.exists?("config/prod.secret.exs") do
  import_config "prod.secret.exs"
end
