defmodule Pelable.Repo.Migrations.AddTypeChatroomTable do
  use Ecto.Migration

  def change do
    alter table(:chatrooms) do
      add :type, :string
    end
  end
end
