defmodule Pelable.Repo.Migrations.ModifyWorkspacesTable do
  use Ecto.Migration

  def change do
    alter table(:workspaces) do
      remove :type
    end
  end
end