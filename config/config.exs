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
  pubsub: [name: Pelable.PubSub, adapter: Phoenix.PubSub.PG2]

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
  cache_store_backend: Pow.Store.Backend.MnesiaCache
  extensions: [PowResetPassword, PowEmailConfirmation, PowPersistentSession],
  controller_callbacks: Pow.Extension.Phoenix.ControllerCallbacks,
  mailer_backend: PelableWeb.PowMailer,
  web_mailer_module: PelableWeb

  config :pow, PelableWeb.PowMailer,
  adapter: Swoosh.Adapters.Mailgun,
  api_key: System.get_env("MAILGUN_API_KEY"),
  domain: "mail1.pelable.com"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"

