defmodule Pelable.Repo.Migrations.DropProjectBookmarkTable do
  use Ecto.Migration

  def change do
    drop_if_exists table("project_bookmark")
  end
end
