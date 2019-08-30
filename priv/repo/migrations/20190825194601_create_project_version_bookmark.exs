defmodule Pelable.Repo.Migrations.CreateProjectVersionBookmark do
  use Ecto.Migration

  def change do
    create table(:project_bookmark) do
      add :user_id, references(:users)
      add :work_project_id, references(:work_projects)
    end
    create unique_index(:project_bookmark, [:user_id, :work_project_id])
  end
end
