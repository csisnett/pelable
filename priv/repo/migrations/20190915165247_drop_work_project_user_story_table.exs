defmodule Pelable.Repo.Migrations.DropWorkProjectUserStoryTable do
  use Ecto.Migration

  def change do
    drop_if_exists table("work_project_user_story")
  end
end
