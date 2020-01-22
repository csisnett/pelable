defmodule Pelable.Repo.Migrations.CreateSections do
  use Ecto.Migration

  def change do
    create table(:sections) do
      add :name, :string, null: false
      add :uuid, :uuid, null: false
      add :slug, :string, null: false
      add :workspace_id, references(:workspaces, on_delete: :nothing)

      timestamps()
    end

    create unique_index(:sections, [:uuid])
    create index(:sections, [:workspace_id])
    create unique_index(:sections, [:workspace_id, :slug], name: :unique_slug_name_index)
  end
end
