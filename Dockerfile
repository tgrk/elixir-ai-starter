ARG ELIXIR_VERSION=1.20.1
ARG OTP_VERSION=28.3.2
ARG DEBIAN_VERSION=bookworm-20260610-slim
FROM hexpm/elixir:${ELIXIR_VERSION}-erlang-${OTP_VERSION}-debian-${DEBIAN_VERSION} AS builder

RUN apt-get update && apt-get install -y --no-install-recommends build-essential git \
    && rm -rf /var/lib/apt/lists/*
WORKDIR /app
ENV MIX_ENV=prod
RUN mix local.hex --force && mix local.rebar --force
COPY mix.exs mix.lock ./
COPY config config
RUN mix deps.get --only prod && mix deps.compile
COPY lib lib
RUN mix compile --warnings-as-errors && mix release

FROM debian:bookworm-20260610-slim
RUN apt-get update && apt-get install -y --no-install-recommends libstdc++6 openssl libncurses6 ca-certificates \
    && rm -rf /var/lib/apt/lists/*
ENV LANG=C.UTF-8
WORKDIR /app
COPY --from=builder --chown=nobody:nogroup /app/_build/prod/rel/elixir_ai_starter ./
USER nobody
CMD ["bin/elixir_ai_starter", "start"]
