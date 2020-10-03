defmodule Pelable.Repo.Migrations.CreateHabitcompletion do
  use Ecto.Migration

  def change do
    create table(:habit_completion) do
      add :created_at_local_datetime, :naive_datetime, null: false
      add :local_timezone, :string, null: false
      add :streak_id, references(:streaks, on_delete: :delete_all), null: false
      

      timestamps()
    end
    create index(:habit_completion, [:streak_id])
  end
end
