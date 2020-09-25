defmodule Pelable.Repo.Migrations.ModifyProjectsDeleteWorkspace do
  use Ecto.Migration

  def change do
    alter table(:projects) do
      remove :workspace_id
    end
  end
end
