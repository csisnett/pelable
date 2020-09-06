defmodule Pelable.Repo.Migrations.ModifyWorkspacesTable do
  use Ecto.Migration

  def change do
    alter table(:workspaces) do
      add :personal?, :boolean, null: false
      remove :type
    end
  end
end
