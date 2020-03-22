defmodule Pelable.Repo.Migrations.DropWorkProjectsTable do
  use Ecto.Migration

  def change do
    drop_if_exists table("work_projects")
  end
end
