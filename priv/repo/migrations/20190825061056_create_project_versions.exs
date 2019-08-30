defmodule Pelable.Repo.Migrations.CreateProjectVersions do
  use Ecto.Migration

  def change do
    create table(:project_versions) do
      add :first?, :boolean
      add :added_by_id, references(:users, on_delete: :nothing)
      add :parent_id, references(:project_versions, on_delete: :nothing)

      timestamps()
    end
    create index(:project_versions, [:added_by_id])
    create index(:project_versions, [:parent_id])
  end
end
