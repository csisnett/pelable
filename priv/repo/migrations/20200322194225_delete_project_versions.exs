defmodule Pelable.Repo.Migrations.DeleteProjectVersions do
  use Ecto.Migration

  def change do
    drop_if_exists table("project_versions")
  end
end
