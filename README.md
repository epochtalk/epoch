# Epoch

##### Dependencies

* Ecto
* Postgrex
* Distillery

##### Build/Deploy

`MIX_ENV=prod mix do compile, release --env=prod --verbose`

##### Running

Setup Erlang/Elixir: http://elixir-lang.org/install.html
OS X (AKA easy mode): brew install elixir

```
mix deps.get
mix ecto.setup
```

##### Breakdown

 * `mix ecto.drop` - drop db
 * `mix ecto.create` - create new db
 * `mix ecto.migrate` - migration

Configuration of database settings are in config/config.exs
