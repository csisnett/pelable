defmodule Pelable.Repo.Migrations.CreateTasks do
  use Ecto.Migration

  def change do
    create table(:tasks) do
      add :name, :string, null: false
      add :status, :string, null: false
      add :uuid, :uuid, null: false
      add :slug, :string, null: false
      add :creator_id, references(:users, on_delete: :delete_all), null: false

      timestamps()
    end
    create index(:tasks, [:creator_id])
    create unique_index(:tasks, [:uuid])
  end
end
