defmodule Pelable.Repo.Migrations.CreateProjects do
  use Ecto.Migration

  def change do
    create table(:projects) do
      add :name, :string, null: false
      add :slug, :string
      add :description, :text
      add :uuid, :uuid, null: false
      add :workspace_id, references(:workspaces, on_delete: :delete_all), null: false
      add :creator_id, references(:users)

      timestamps()
    end

    create unique_index(:projects, [:uuid])
    create index(:projects, [:workspace_id])
    create index(:projects, [:creator_id])
  end
end
