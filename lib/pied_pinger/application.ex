defmodule PiedPinger.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    topologies = Application.get_env(:libcluster, :topologies) || []
    children = [
      {Cluster.Supervisor, [topologies, [name: PiedPinger.ClusterSupervisor]]},
      # Start the Telemetry supervisor
      PiedPingerWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: PiedPinger.PubSub},

      PiedPinger.PingServer,

      # Start the Endpoint (http/https)
      PiedPingerWeb.Endpoint
      # Start a worker by calling: PiedPinger.Worker.start_link(arg)
      # {PiedPinger.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: PiedPinger.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    PiedPingerWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
