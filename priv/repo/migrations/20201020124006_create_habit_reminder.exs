defmodule Pelable.Repo.Migrations.CreateHabitReminder do
  use Ecto.Migration

  def change do
    create table(:habit_reminder) do
      add :habit_id, references(:habits, on_delete: :delete_all), null: false
      add :reminder_id, references(:reminders, on_delete: :delete_all), null: false
      timestamps()
    end
    create index(:habit_reminder, [:habit_id])
    create index(:habit_reminder, [:reminder_id])
  end
end
