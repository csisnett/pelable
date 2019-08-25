defmodule Pelable.Repo.Migrations.CreateProjectVersionUserStory do
  use Ecto.Migration

  def change do
    create table(:project_version_user_story) do
      add :project_version_id, references(:project_versions)
      add :user_story_id, references(:user_stories)
    end

    create unique_index(:project_version_user_story, [:project_version_id, :user_story_id])
  end
end
