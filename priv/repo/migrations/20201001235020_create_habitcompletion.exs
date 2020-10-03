defmodule Pelable.Repo.Migrations.CreateHabitcompletion do
  use Ecto.Migration

  def change do
    create table(:habit_completion) do
      add :streak_id, references(:streaks, on_delete: :delete_all), null: false
      add :created_at_local_datetime, :naive_datetime

      timestamps()
    end
    create index(:habit_completion, [:streak_id])
  end
end
