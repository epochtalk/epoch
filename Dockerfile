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

CMD until mix do ecto.create, ecto.migrate; do sleep 1; done
