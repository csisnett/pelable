defmodule Pelable.Repo.Migrations.AddProjectTagTable do
  use Ecto.Migration

  def change do
    create table(:project_version_tag) do
      add :project_version_id, references(:project_versions, on_delete: :nothing)
      add :tag_id, references(:tags, on_delete: :nothing)

      timestamps()
    end

    create index(:project_version_tag, [:project_version_id])
    create index(:project_version_tag, [:tag_id])
    create unique_index(:project_version_tag, [:project_version_id, :tag_id])

  end
end
