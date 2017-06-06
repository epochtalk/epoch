# Epoch

##### Dependencies

* Ecto
* Postgrex
* Distillery

##### Build/Deploy

`MIX_ENV=prod mix do compile, release --env=prod --verbose`

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
