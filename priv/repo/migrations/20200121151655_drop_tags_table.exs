defmodule Pelable.Repo.Migrations.DropTagsTable do
  use Ecto.Migration

  def change do
    drop_if_exists table("tags")
  end
end
