defmodule Pelable.Repo.Migrations.DropWorkspaceMemberTable do
  use Ecto.Migration

  def change do
    drop table("workspace_member")
  end
end
