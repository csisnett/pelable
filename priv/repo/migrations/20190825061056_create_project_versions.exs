defmodule Pelable.Repo.Migrations.CreateProjectVersions do
  use Ecto.Migration

  def change do
    create table(:project_versions) do
      add :description, :text
      add :name, :string
      add :public_status, :string
      add :first?, :boolean
      add :project_version_id, references(:project_versions)
      add :creator_id, references(:users, on_delete: :nothing)
      add :parent_id, references(:project_versions, on_delete: :nothing)
      add :project_id, references(:projects, on_delete: :nothing)

      timestamps()
    end
  end
end
