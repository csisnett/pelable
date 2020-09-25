defmodule Pelable.Repo.Migrations.DropWorkspacesTable do
  use Ecto.Migration

  def change do
    drop table("workspaces")
  end
end
