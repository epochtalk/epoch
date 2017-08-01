FROM elixir:1.4
RUN mix local.hex --force
RUN mix local.rebar --force
ADD . .
RUN mix deps.get

# enable configuration by environment
COPY config/deploy.secret.exs config/prod.secret.exs

# compile for production
ENV MIX_ENV=prod
RUN mix compile

CMD mix do ecto.create, ecto.migrate
