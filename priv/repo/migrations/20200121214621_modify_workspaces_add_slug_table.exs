defmodule Pelable.Repo.Migrations.ModifyWorkspacesAddSlugTable do
  use Ecto.Migration

  def change do
    alter table(:workspaces) do
      add :slug, :string, null: false
    end
  end
end
