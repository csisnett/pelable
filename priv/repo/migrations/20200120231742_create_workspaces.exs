defmodule Pelable.Repo.Migrations.CreateWorkspaces do
  use Ecto.Migration

  def change do
    create table(:workspaces) do
      add :name, :string, null: false
      add :type, :string, null: false
      add :uuid, :uuid, null: false
      
      add :creator_id, references(:users, on_delete: :nothing), null: false
      add :chatroom_id, references(:chatrooms, on_delete: :nothing), null: false

      timestamps()
    end

    create index(:workspaces, [:creator_id])
    create unique_index(:workspaces, [:chatroom_id])
    create unique_index(:workspaces, [:uuid])
  end
end
