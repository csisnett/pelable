defmodule Pelable.Repo.Migrations.AddExpiredAtChatroomTable do
  use Ecto.Migration

  def change do
    alter table(:chatrooms) do
      add :expires_at, :string
      add :expired?, :boolean
    end
  end
end
