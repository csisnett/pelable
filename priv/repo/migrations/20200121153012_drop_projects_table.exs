defmodule Pelable.Repo.Migrations.DropProjectsTable do
  use Ecto.Migration

  def change do
    drop_if_exists table("projects")
  end
end
