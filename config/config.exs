# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

# Configures the endpoint
config :pied_pinger, PiedPingerWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "X/iC1qVKKrGFHLVw9ajR8o+Rk77+2nl/yo70Cc2f+exOInbpzglBR/50zNZVIOdr",
  render_errors: [view: PiedPingerWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: PiedPinger.PubSub,
  live_view: [signing_salt: "3ELimCjo"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :libcluster,
  # debug: true,
  topologies: [
    default: [
      strategy: Cluster.Strategy.Gossip
    ]
  ]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
