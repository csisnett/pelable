defmodule Pelable.Habits.Streak do
  use Ecto.Schema
  import Ecto.Changeset
  alias Pelable.Habits.Habit

  schema "streaks" do
    belongs_to :habit, Habit

    timestamps()
  end

  @doc false
  def changeset(streak, attrs) do
    streak
    |> cast(attrs, [:habit_id])
    |> validate_required([:habit_id])
    |> foreign_key_constraint(:habit_id)
  end
end
