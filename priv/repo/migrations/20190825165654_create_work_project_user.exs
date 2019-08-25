defmodule Pelable.Repo.Migrations.CreateWorkProjectUser do
  use Ecto.Migration

  def change do
    create table(:work_project_user) do
      add :user_id, references(:users)
      add :work_project_id, references(:work_projects)
    end

    create unique_index(:work_project_user, [:user_id, :work_project_id])
  end
end
