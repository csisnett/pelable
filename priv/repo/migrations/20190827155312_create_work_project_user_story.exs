defmodule Pelable.Repo.Migrations.CreateWorkProjectUserStory do
  use Ecto.Migration

  def change do
    create table(:work_project_user_story) do
      add :status, :string
      add :work_project_id, references(:work_projects, on_delete: :nothing)
      add :user_story_id, references(:user_stories, on_delete: :nothing)

      timestamps()
    end

    create index(:work_project_user_story, [:work_project_id])
    create index(:work_project_user_story, [:user_story_id])
    create unique_index(:work_project_user_story, [:work_project_id, :user_story_id])
  end
end
