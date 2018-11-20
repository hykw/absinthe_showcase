# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :showcase, ecto_repos: [Showcase.Repo]

# Configures the endpoint
config :showcase, ShowcaseWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "kRX2OgLgebgkAjI43SbvKfMd83xcPx9r9vpdduPoMZAMdyl10Gj1gKYgP20YmMGm",
  render_errors: [view: ShowcaseWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Showcase.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
