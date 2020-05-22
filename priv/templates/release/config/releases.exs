import Config

# Database
database_url =
  System.get_env("DATABASE_URL") ||
    raise """
    environment variable DATABASE_URL is missing.
    For example: ecto://USER:PASS@HOST/DATABASE
    """

database_pool_size = System.get_env("POOL_SIZE") || "10"

config :<%= @project_name %>, <%= @camelcase_project_name %>.Repo,
  # ssl: true,
  url: database_url,
  pool_size: String.to_integer(database_pool_size)

# Endpoint
secret_key_base =
  System.get_env("SECRET_KEY_BASE") ||
    raise """
    environment variable SECRET_KEY_BASE is missing.
    You can generate one by calling: mix phx.gen.secret
    """

port = System.get_env("PORT") || "4000"

<%
project_name = if @type == :umbrella do
  "#{@project_name}_web"
else
  @project_name
end
%>
config :<%= project_name %>, <%= @camelcase_project_name %>Web.Endpoint,
  http: [:inet6, port: String.to_integer(port)],
  secret_key_base: secret_key_base,
  # required by mix release
  server: true