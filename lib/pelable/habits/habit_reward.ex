defmodule Pelable.Habits.HabitReward do
  use Ecto.Schema
  import Ecto.Changeset

  # Represents a reward the completion of this habit could create
  alias Pelable.Habits.{Reward, Habit}

  schema "habit_reward" do
    belongs_to :reward, Reward
    belongs_to :habit, Habit

    timestamps()
  end

  @doc false
  def changeset(habit_reward, attrs) do
    habit_reward
    |> cast(attrs, [:reward_id, :habit_id])
    |> validate_required([:reward_id, :habit_id])
    |> foreign_key_constraint(:reward_id)
    |> foreign_key_constraint(:habit_id)
  end
end
