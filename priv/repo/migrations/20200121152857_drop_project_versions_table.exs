defmodule Pelable.Repo.Migrations.DropProjectVersionsTable do
  use Ecto.Migration

  def change do
    drop_if_exists table("projects_versions")
  end
end
