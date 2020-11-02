defmodule Pelable.MixProject do
  use Mix.Project

  def project do
    [
      app: :pelable,
      version: "0.1.0",
      elixir: "~> 1.11.1",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {Pelable.Application, []},
      extra_applications: [:logger, :runtime_tools, :swoosh]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:phoenix, "~> 1.5.5"},
      {:phoenix_pubsub, "~> 2.0"},
      {:phoenix_ecto, "~> 4.2.1"},
      {:ecto_sql, "~> 3.4.5"},
      {:postgrex, ">= 0.15.6"},
      {:phoenix_html, "~> 2.14.2"},
      {:phoenix_live_reload, "~> 1.2.4", only: :dev},
      {:gettext, "~> 0.18.1"},
      {:jason, "~> 1.2.2"},
      {:plug_cowboy, "~> 2.3.0"},
      {:pow, "~> 1.0.21"},
      {:html_sanitize_ex, "~> 1.4.1"},
      {:earmark, "~> 1.4.10"},
      {:ecto_autoslug_field, "~> 2.0.1"},
      {:ecto_shortuuid, "~> 0.1.3"},
      {:swoosh, "~> 0.23.5"},
      {:plug_attack, "~> 0.4.2"},
      {:remote_ip, "~> 0.1.5"},
      {:redix, "~> 0.10.2"},
      {:castore, "~> 0.1.7"},
      {:cors_plug, "~> 2.0.2"},
      {:httpoison, "~> 1.7.0"},
      {:bodyguard, "~> 2.4.0"},
      {:tzdata, "~> 1.0.3"}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate", "test"]
    ]
  end
end
