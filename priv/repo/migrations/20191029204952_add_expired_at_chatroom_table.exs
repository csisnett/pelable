defmodule Pelable.Repo.Migrations.AddExpiredAtChatroomTable do
  use Ecto.Migration

  def change do
    alter table(:chatrooms) do
      add :expires_at, :utc_datetime
      add :expired?, :boolean
    end
  end
end
