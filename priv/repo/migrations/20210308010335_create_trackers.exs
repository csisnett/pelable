defmodule Pelable.Repo.Migrations.CreateTrackers do
  use Ecto.Migration

  def change do
    create table(:trackers) do
      add :name, :string
      add :uuid, :uuid, null: false
      add :tracking_user_id, references(:users, on_delete: :delete_all), null: false
      timestamps()
    end
    create unique_index(:trackers, [:uuid])
    create index(:trackers, [:tracking_user_id])
  end
end
