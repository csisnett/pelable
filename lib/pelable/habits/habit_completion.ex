defmodule Pelable.Habits.HabitCompletion do
  use Ecto.Schema
  import Ecto.Changeset
  alias Pelable.Habits.Streak

  schema "habit_completion" do
    field :created_at_local_datetime, :naive_datetime

    belongs_to :streak, Streak
    timestamps()
  end

  @doc false
  def changeset(habit_completion, attrs) do
    habit_completion
    |> cast(attrs, [:streak_id, :created_at_local_datetime])
    |> validate_required([:streak_id, :created_at_local_datetime])
  end
end
