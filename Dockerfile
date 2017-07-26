FROM elixir:1.4
RUN mix local.hex --force
RUN mix local.rebar --force
ADD . .
RUN mix deps.get
RUN mix
CMD mix do ecto.create, ecto.migrate
