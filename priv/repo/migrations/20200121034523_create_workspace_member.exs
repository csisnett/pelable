defmodule Pelable.Repo.Migrations.CreateWorkspaceMember do
  use Ecto.Migration

  def change do
    create table(:workspace_member) do
      add :role, :string, null: false
      add :user_id, references(:users, on_delete: :delete_all), null: false
      add :workspace_id, references(:workspaces, on_delete: :delete_all), null: false

      timestamps()
    end

    create index(:workspace_member, [:user_id])
    create index(:workspace_member, [:workspace_id])
    create unique_index(:workspace_member, [:user_id, :workspace_id])
  end
end
