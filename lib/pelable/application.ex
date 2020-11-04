defmodule Pelable.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @redis_url System.get_env("REDIS_URL")

  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      # Start the Ecto repository
      Pelable.Repo,
      # Start the endpoint when the application starts
      PelableWeb.Endpoint,
      # Starts a worker by calling: Pelable.Worker.start_link(arg)
      # {Pelable.Worker, arg},

      {Phoenix.PubSub, [name: Pelable.PubSub, adapter: Phoenix.PubSub.PG2]},
      
      {Redix, {@redis_url, [name: :redix]}},
      # # Or in a distributed system:
      # {Pow.Store.Backend.MnesiaCache, extra_db_nodes: Node.list()},
      # Pow.Store.Backend.MnesiaCache.Unsplit # Recover from netsplit

      PelableWeb.Presence,
      
      {PlugAttack.Storage.Ets, name: Pelable.PlugAttack.Storage, clean_period: 60_000},
      {Oban, oban_config()}
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

  defp oban_config do
    Application.get_env(:pelable, Oban)
  end
end
