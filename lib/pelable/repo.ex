defmodule Pelable.Repo do
  use Ecto.Repo,
    otp_app: :pelable,
    adapter: Ecto.Adapters.Postgres,
    pool_size: 70

    def init(_type, config) do
      {:ok, Keyword.put(config, :url, System.get_env("DATABASE_URL"))}
    end
end
