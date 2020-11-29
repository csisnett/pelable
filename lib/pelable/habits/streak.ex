defmodule Pelable.Habits.Streak do
  use Ecto.Schema
  import Ecto.Changeset
  alias Pelable.Habits.{Habit, StreakSaver}

  #A streak is created when a habit is created first and later whenever a habit completion is done and the last streak isn't alive
  # In the second case the habit completion of course belongs to the newly created streak

  schema "streaks" do
    field :count, :integer, virtual: true
    belongs_to :habit, Habit
    has_many :streak_savers, StreakSaver
    
    timestamps()
  end

  @doc false
  def changeset(streak, attrs) do
    streak
    |> cast(attrs, [:habit_id, :count])
    |> validate_required([:habit_id])
    |> foreign_key_constraint(:habit_id)
  end
end
