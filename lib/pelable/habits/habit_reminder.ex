defmodule Pelable.Habits.HabitReminder do
  use Ecto.Schema
  import Ecto.Changeset

  alias Pelable.Habits.{Habit, Reminder}

  schema "habit_reminder" do

    belongs_to :habit, Habit
    belongs_to :reminder, Reminder
    timestamps()
  end

  @doc false
  def changeset(habit_reminder, attrs) do
    habit_reminder
    |> cast(attrs, [:habit_id, :reminder_id])
    |> validate_required([:habit_id, :reminder_id])
  end
end
