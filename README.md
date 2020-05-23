# phx_custom

> Opinioned code patcher for projects generated by `mix phx.new`.

## Dependencies

- Node.js >= 9.11.2
- Phoenix >= 1.5.0

> Extractor of PurgeCSS is using a regular expression which is only compatible with Node.js >= 9.11.2.

## Features

phx_custom provides following Mix tasks:

- `mix phx.custom.web`
- `mix phx.custom.release`
- `mix phx.custom.docker`

### `mix phx.custom.web`

This Mix task provides:

- enhanced assets pipeline:
  - built-in [tailwindcss](https://tailwindcss.com/) support
  - source map support for JavaScript and CSS
- separation for app and admin:
  - standalone frontend resources for app and admin
  - standalone namespaces for app and admin views

> What is the meaning of app or admin?
> Generally, a web application consists of two sub applications, one for users, one for administrators. In the context of **phx_custom**, the code for users is called **app**, the code for administrators is called **admin**.

## Installation

Install latest version:

```sh
mix archive.install github c4710n/phx_custom
```

Install released version on [Hex.pm](https://hex.pm/):

```
mix archive.install hex phx_custom
```

## Usage

A general process for initializing a new project:

```sh
# create an project
$ mix phx.new project
$ cd project

# patch custom web template
$ mix phx.custom.web .

# install dependencies
$ mix deps.get

# patch project for using `mix release`
$ mix phx.custom.release .

# run
$ mix ecto.create
$ mix phx.server

# patch Dockerfile
$ mix phx.custom.docker .

# build an image for production
$ docker build -t project .
```

## License

MIT
