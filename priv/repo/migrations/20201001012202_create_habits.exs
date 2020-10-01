defmodule Pelable.Repo.Migrations.CreateHabits do
  use Ecto.Migration

  def change do
    create table(:habits) do
      add :name, :string, null: false
      add :time_frequency, :string, null: false
      add :archived?, :boolean, default: false, null: false
      add :uuid, :uuid, null: false

      add :user_id, references(:users, on_delete: :delete_all), null: false

      timestamps()
    end
    create index(:habits, [:user_id])
    create unique_index(:habits, [:uuid])
  end
end
