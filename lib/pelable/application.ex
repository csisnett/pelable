defmodule Pelable.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    # List all child processes to be supervised
    topologies = Application.get_env(:libcluster, :topologies) || []
    children = [
      # Start the Ecto repository
      Pelable.Repo,
      
      #start libcluster
      {Cluster.Supervisor, [topologies, [name: Pelable.ClusterSupervisor]]},
      # Start the endpoint when the application starts
      PelableWeb.Endpoint,
      # Starts a worker by calling: Pelable.Worker.start_link(arg)
      # {Pelable.Worker, arg},

      Pow.Store.Backend.MnesiaCache,
      # # Or in a distributed system:
      # {Pow.Store.Backend.MnesiaCache, extra_db_nodes: Node.list()},
      # Pow.Store.Backend.MnesiaCache.Unsplit # Recover from netsplit

      PelableWeb.Presence,
      
      {PlugAttack.Storage.Ets, name: Pelable.PlugAttack.Storage, clean_period: 60_000}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Pelable.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    PelableWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
