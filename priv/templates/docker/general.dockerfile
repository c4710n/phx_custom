# Dockerfile for Phoenix project.

# > Global args
# https://github.com/moby/moby/issues/37345#issuecomment-400245466

# customizable args
ARG RELEASE_NAME=<%= @project_name %>
ARG PORT=4000
ARG HEALTHCHECK_PATH=/health-check

# internal args
ARG MIX_ENV=prod
ARG WORK_DIR=/app
ARG ASSETS_DIR=assets


# > Base image with compiling deps
FROM elixir:1.11-alpine AS base

# args
ARG MIX_ENV
ARG WORK_DIR

# envs
ENV MIX_ENV $MIX_ENV

# preparation
RUN mkdir -p $WORK_DIR
WORKDIR $WORK_DIR

RUN apk add --no-cache git

# install hex + rebar
RUN mix local.hex --force
RUN mix local.rebar --force

# install mix dependencies
COPY mix.exs mix.lock ./
COPY config config/
RUN mix deps.get --only $MIX_ENV
RUN mix deps.compile


# > Build assets
FROM node:14-alpine AS assets-builder

# args
ARG WORK_DIR
ARG ASSETS_DIR

# preparation
RUN mkdir -p $WORK_DIR
WORKDIR $WORK_DIR

# install npm dependencies
COPY --from=base $WORK_DIR/deps deps/
COPY $ASSETS_DIR/package.json $ASSETS_DIR/
COPY $ASSETS_DIR/package-lock.json $ASSETS_DIR/
RUN npm install --prefix $ASSETS_DIR

# copy source code
# when buliding assets, analyzing eex files would be required.
# in case of omitting files, we copy them all.
COPY . ./

# build
COPY $ASSETS_DIR $ASSETS_DIR/
RUN npm run deploy --prefix $ASSETS_DIR


# > Assemble release
FROM base AS release-assembler

# args
ARG WORK_DIR

# compile
COPY . ./
RUN mix compile

# digest and compress assets
ARG STATIC_DIR=priv/static
COPY --from=assets-builder $WORK_DIR/$STATIC_DIR $STATIC_DIR/
RUN mix phx.digest

# release
RUN mix release


# > Final
FROM elixir:1.11-alpine

# args
ARG MIX_ENV
ARG WORK_DIR
ARG RELEASE_NAME
ARG PORT
ARG HEALTHCHECK_PATH

# envs
ENV HOME $WORK_DIR
ENV RELEASE_NAME $RELEASE_NAME
ENV PORT $PORT
ENV HEALTHCHECK_PATH $HEALTHCHECK_PATH

# preparation
RUN mkdir -p $WORK_DIR
WORKDIR $WORK_DIR

RUN apk add --no-cache curl

# copy release
COPY --from=release-assembler \
  --chown=nobody:nobody \
  $WORK_DIR/_build/$MIX_ENV ./

# limit permissions
USER nobody:nobody

# health check
HEALTHCHECK --start-period=30s --interval=5s --timeout=3s --retries=3 \
  CMD curl -o /dev/null -s -f http://localhost:$PORT$HEALTHCHECK_PATH

EXPOSE $PORT
ENTRYPOINT ./rel/$RELEASE_NAME/bin/$RELEASE_NAME start
