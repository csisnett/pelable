defmodule Pelable.Repo.Migrations.AddChatroomInvitationsTable do
  use Ecto.Migration

  def change do
    create table(:chatroom_invitation) do
      add :user_id, references(:users)
      add :chatroom_id, references(:chatrooms)
    end
    create unique_index(:chatroom_invitation, [:user_id, :chatroom_id])
  end
end
