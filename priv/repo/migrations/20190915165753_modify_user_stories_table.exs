defmodule Pelable.Repo.Migrations.ModifyUserStoriesTable do
  use Ecto.Migration

  def change do
    alter table(:user_stories) do
      add :work_project_id, references(:work_projects)
      add :status, :string, null: false
      add :required?, :boolean
      add :uuid, :uuid, null: false
  end
  drop index(:user_stories, [:title])
  create index(:user_stories, [:title])
  create unique_index(:user_stories, [:uuid])
end
end
