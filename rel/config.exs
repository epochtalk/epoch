use Mix.Releases.Config,
  default_release: :epoch,
  default_environment: Mix.env

environment :dev do
  set dev_mode: true 
  set include_erts: false
  set include_system_libs: false
  set cookie: :dev
end

environment :prod do
  set include_erts: false
  set include_system_libs: false
  set cookie: :prod
end

release :epoch do
  set version: current_version(:epoch)
end
