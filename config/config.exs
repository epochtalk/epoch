import Config

# General application configuration
config :epoch,
  ecto_repos: [Epoch.Repo]

config :epoch, Epoch,
  enable_smf_fallback: false

# Configures the endpoint
config :epoch, EpochWeb.Endpoint,
  url: [host: "localhost"]

config :epoch, EpochLegacyWeb.Endpoint,
  url: [host: "localhost"]

config :epoch, Epoch.SmfRepo,
  select_cols: %{
    smf_members: ["ID_GROUP", "AIM", "ignoreBoards", "ICQ", "notifyTypes", "ID_MSG_LAST_VISIT", "smileySet", "YIM", "lngfile", "activity", "notifySendBody", "additionalGroups", "timeFormat", "ID_MEMBER", "ID_POST_GROUP", "MSN", "avatar", "hideEmail", "personaltext", "notifyAnnouncements", "timeOffset", "autoWatch", "websiteTitle", "is_activated", "location", "gender", "emailAddress", "birthdate", "usertitle", "lastpatrolled", "showOnline", "notifyOnce", "proxyban", "maxdepth", "websiteUrl", "ID_THEME", "ign_ignore_list", "realName", "memberName", "pm_email_notify", "posts", "lastLogin", "signature", "dateRegistered", "lastUpdated", "totalTimeLoggedIn"]
  }

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :epoch, Epoch.Mailer, adapter: Swoosh.Adapters.Local

# Swoosh API client is needed for adapters other than SMTP.
config :swoosh, :api_client, false

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
