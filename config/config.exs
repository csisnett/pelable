# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :pelable,
  ecto_repos: [Pelable.Repo]

# Configures the endpoint
config :pelable, PelableWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "rco4O02JtEqNj3mWNwfw1MpK/tHqZSKMvYRSiYQy1LGTzudZk38ohbHOlBlXEhNd",
  render_errors: [view: PelableWeb.ErrorView, accepts: ~w(html json)],
  pubsub_server: Pelable.PubSub

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :pelable, :pow,
  user: Pelable.Users.User,
  repo: Pelable.Repo,
  web_module: PelableWeb,
  cache_store_backend: PelableWeb.PowRedisCache,
  extensions: [PowResetPassword, PowPersistentSession],
  controller_callbacks: Pow.Extension.Phoenix.ControllerCallbacks,
  mailer_backend: PelableWeb.PowMailer,
  web_mailer_module: PelableWeb,
  routes_backend: PelableWeb.Pow.Routes

  config :pow, PelableWeb.PowMailer,
  adapter: Swoosh.Adapters.Sendgrid,
  api_key: "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"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"

