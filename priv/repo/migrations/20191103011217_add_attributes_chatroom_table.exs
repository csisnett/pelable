defmodule Pelable.Repo.Migrations.AddAttributesChatroomTable do
  use Ecto.Migration

  def change do
    alter table(:chatrooms) do
      add :properties, :map
    end
    rename table("chatrooms"), :expired?, to: :moved?
  end
end
