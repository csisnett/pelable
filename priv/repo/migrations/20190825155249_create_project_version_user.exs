defmodule Pelable.Repo.Migrations.CreateProjectVersionUser do
  use Ecto.Migration

  def change do
    create table(:project_version_user) do
      add :user_id, references(:users)
      add :project_version_id, references(:project_versions)
    end
    create unique_index(:project_version_user, [:user_id, :project_version_id])
  end
end
