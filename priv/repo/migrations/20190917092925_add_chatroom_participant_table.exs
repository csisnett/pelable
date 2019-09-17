defmodule Pelable.Repo.Migrations.AddChatroomParticipantTable do
  use Ecto.Migration

  def change do
    create table(:chatroom_participant) do
      add :user_id, references(:users)
      add :chatroom_id, references(:chatrooms)
    end
    create unique_index(:chatroom_participant, [:user_id, :chatroom_id])
  end
end
