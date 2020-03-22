defmodule Pelable.Repo.Migrations.DropProjectTagTable do
  use Ecto.Migration

  def change do
    drop_if_exists table("project_version_tag")
  end
end
