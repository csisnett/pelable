defmodule Pelable.Repo.Migrations.CreateWorkProjectUser do
  use Ecto.Migration

  def change do
    create table(:project_contributors) do
      add :user_id, references(:users)
      add :work_project_id, references(:work_projects)
    end

    create unique_index(:project_contributors, [:user_id, :work_project_id],
    name: :unique_user_work_project)
  end
end
