defmodule Pelable.Repo do
  use Ecto.Repo,
    otp_app: :pelable,
    adapter: Ecto.Adapters.Postgres
end
