defmodule Pelable.Repo.Migrations.CreateStreaks do
  use Ecto.Migration

  def change do
    create table(:streaks) do
      add :habit_id, references(:habits, on_delete: :delete_all), null: false

      timestamps()
    end
    create index(:streaks, [:habit_id])
  end
end
