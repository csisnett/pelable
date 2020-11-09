defmodule Pelable.Repo.Migrations.CreateResources do
  use Ecto.Migration

  def change do
    create table(:resources) do
      add :url, :string, null: false
      add :uuid, :uuid, null: false
      add :creator_id, references(:users, on_delete: :delete_all), null: false
      timestamps()
    end
    create unique_index(:resources, [:uuid])
    create unique_index(:resources, [:url])
    create index(:resources, [:creator_id])
  end
end
