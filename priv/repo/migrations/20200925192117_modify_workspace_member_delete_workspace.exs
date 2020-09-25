defmodule Pelable.Repo.Migrations.ModifyWorkspaceMemberDeleteWorkspace do
  use Ecto.Migration

  def change do
    alter table(:workspace_member) do
      remove :workspace_id
    end
  end
end