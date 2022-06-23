import Config

# General application configuration
config :epoch,
  ecto_repos: [Epoch.Repo]

config :epoch, Epoch,
  enable_smf_fallback: false

# Configure Guardian
config :epoch, Epoch.Guardian,
       issuer: "Epoch",
       # TODO: configure this at runtime through env
       secret_key: "Secret key. You can use `mix guardian.gen.secret` to get one"

# Configure Guardian.DB
config :guardian, Guardian.DB,
  repo: GuardianRedis.Repo
  # schema_name: "guardian_tokens" # default
  # token_types: ["refresh_token"] # store all token types if not set

# Configure GuardianRedis
# (implementation of Guardian.DB storage in redis)
config :guardian_redis, :redis,
  host: "127.0.0.1",
  port: 6379,
  pool_size: 10

# Configures the endpoint
config :epoch, EpochWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [view: EpochWeb.ErrorView,
    format: "json",
    accepts: ~w(json)]

config :epoch, EpochLegacyWeb.Endpoint,
  url: [host: "localhost"]

config :epoch, Epoch.SmfRepo,
  select_cols: %{
    smf_members: ["ID_GROUP", "AIM", "ignoreBoards", "ICQ", "notifyTypes", "ID_MSG_LAST_VISIT", "smileySet", "YIM", "lngfile", "activity", "notifySendBody", "additionalGroups", "timeFormat", "ID_MEMBER", "ID_POST_GROUP", "MSN", "avatar", "hideEmail", "personaltext", "notifyAnnouncements", "timeOffset", "autoWatch", "websiteTitle", "is_activated", "location", "gender", "emailAddress", "birthdate", "usertitle", "lastpatrolled", "showOnline", "notifyOnce", "proxyban", "maxdepth", "websiteUrl", "ID_THEME", "ign_ignore_list", "realName", "memberName", "pm_email_notify", "posts", "lastLogin", "signature", "dateRegistered", "lastUpdated", "totalTimeLoggedIn"]
  }

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
