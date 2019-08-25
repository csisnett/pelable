defmodule Pelable.Repo.Migrations.CreateWorkProjects do
  use Ecto.Migration

  def change do
    create table(:work_projects) do
      add :repo_url, :string
      add :work_status, :string
      add :public_status, :string
      add :start_date, :utc_datetime
      add :end_date, :utc_datetime
      add :description, :text
      add :creator_id, references(:users, on_delete: :nothing)
      add :project_version_id, references(:project_versions, on_delete: :nothing)
      timestamps()
    end

  end
end
