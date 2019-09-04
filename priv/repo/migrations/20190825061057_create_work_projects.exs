defmodule Pelable.Repo.Migrations.CreateWorkProjects do
  use Ecto.Migration

  def change do
    create table(:work_projects) do
      add :name, :string
      add :uuid, :string
      add :repo_url, :string
      add :show_url, :string
      add :work_status, :string
      add :public_status, :string
      add :start_date, :utc_datetime
      add :end_date, :utc_datetime
      add :short_description, :text
      add :description, :text
      add :description_html, :text
      add :creator_id, references(:users, on_delete: :nothing)
      add :project_version_id, references(:project_versions, on_delete: :nothing)
      timestamps()
    end
    create unique_index(:work_projects, [:uuid])
  end
end
