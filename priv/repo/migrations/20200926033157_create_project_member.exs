defmodule Pelable.Repo.Migrations.CreateProjectMember do
  use Ecto.Migration

  def change do
    create table(:project_member) do
      add :withdrawal, :naive_datetime
      add :user_id, references(:users, on_delete: :delete_all), null: false
      add :project_id, references(:projects, on_delete: :delete_all), null: false

      timestamps()
    end
    create index(:project_member, [:user_id])
    create index(:project_member, [:project_id])
    create unique_index(:project_member, [:user_id, :project_id])
  end
end
