defmodule Pelable.Repo.Migrations.DropProjectContributorsTable do
  use Ecto.Migration

  def change do
    drop_if_exists table("project_contributors")
  end
end
