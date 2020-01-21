defmodule Pelable.Repo.Migrations.DropUserStoriesTable do
  use Ecto.Migration

  def change do
    drop_if_exists table("user_stories")
  end
end
