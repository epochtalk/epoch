# Epoch

##### Dependencies

* Ecto
* Postgrex
* Distillery

##### Build/Deploy

Create a `config/prod.secrets.exs` (see
[example.prod.secrets.exs](./config/example.prod.secrets.exs)

Then do:

`MIX_ENV=prod mix do compile, release --env=prod --verbose`

##### Build a Docker image

`docker build -t epoch:[tag] .`

The image will copy `config/deploy.secrets.exs to `config/prod.secrets.exs`, which
allows configuration through environment variables.

```
  username: System.get_env("DATABASE_USER"),
  password: System.get_env("DATABASE_PASSWORD"),
  database: System.get_env("DATABASE_NAME"),
  hostname: System.get_env("DATABASE_HOST"),
```

##### Database Management

Run database migrations:

`_build/prod/rel/epoch/bin/epoch command Elixir.Epoch.ReleaseTasks migrate`

Note `_build/prod/rel/epoch/bin/epoch` can be where the binary is placed once
deployed.

##### Running

Setup Erlang/Elixir: http://elixir-lang.org/install.html
OS X (AKA easy mode): brew install elixir

```
mix deps.get
mix ecto.setup
```

##### Development

 * `mix ecto.drop` - drop db
 * `mix ecto.create` - create new db
 * `mix ecto.migrate` - migration
 * `mix do ecto.drop, ecto.create, ecto.migrate` - drop/create/migrate in 1
   command
Configuration of database settings are in config/config.exs
