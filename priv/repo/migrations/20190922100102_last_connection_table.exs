defmodule Pelable.Repo.Migrations.LastConnectionTable do
  use Ecto.Migration

  def change do
    create table(:last_connection) do
      add :user_id, references(:users)
      add :chatroom_id, references(:chatrooms)
      timestamps()
    end
    create unique_index(:last_connection, [:user_id, :chatroom_id])
  end
end
