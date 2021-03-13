FROM elixir:1.11.3-alpine AS build

# install build dependencies
RUN apk add --no-cache build-base npm git

# prepare build dir
WORKDIR /app

# install hex + rebar
RUN mix local.hex --force && \
  mix local.rebar --force

# set build ENV
ENV MIX_ENV=prod
ENV SECRET_KEY_BASE=wc+TejZzy1sXDp/L39P1GQ3nlnJrv44uJTW+wKdaQmpnyXIuLOZjlJeGAX8rU5lg

# install mix dependencies
COPY mix.exs mix.lock ./
COPY config config
RUN mix do deps.get, deps.compile

# build assets
COPY assets/package.json assets/package-lock.json ./assets/
RUN npm --prefix ./assets ci --progress=false --no-audit --loglevel=error

COPY priv priv
COPY assets assets
RUN npm run --prefix ./assets deploy
RUN mix phx.digest

# compile and build release
COPY lib lib
# uncomment COPY if rel/ exists
# COPY rel rel
RUN mix do compile, release

# prepare release image
FROM alpine:3.13.2 AS app
RUN apk add --no-cache openssl ncurses-libs

WORKDIR /app

RUN chown nobody:nobody /app

USER nobody:nobody

COPY --from=build --chown=nobody:nobody /app/_build/prod/rel/pied_pinger ./

ENV HOME=/app
ENV SECRET_KEY_BASE=wc+TejZzy1sXDp/L39P1GQ3nlnJrv44uJTW+wKdaQmpnyXIuLOZjlJeGAX8rU5lg

CMD ["bin/pied_pinger", "start"]