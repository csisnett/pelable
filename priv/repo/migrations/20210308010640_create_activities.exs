defmodule Pelable.Repo.Migrations.CreateActivities do
  use Ecto.Migration

  def change do
    create table(:activities) do
      add :name, :string, null: false
      add :uuid, :uuid, null: false
      add :started_at_local, :naive_datetime, null: false
      add :terminated_at_local, :naive_datetime
      add :local_timezone, :string, null: false
      add :tracker_id, references(:trackers, on_delete: :delete_all), null: false

      timestamps()
    end
    
    create unique_index(:activities, [:uuid])
    create index(:activities, [:tracker_id])
    
  end
end
