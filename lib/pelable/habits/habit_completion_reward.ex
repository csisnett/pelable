defmodule Pelable.Habits.HabitCompletionReward do
  use Ecto.Schema
  import Ecto.Changeset

  #This Schema represents an Earned Reward (from a habit completion)

  alias Pelable.Habits.{Reward, HabitCompletion}

  @derive {Jason.Encoder, only: [:taken_at_local, :local_timezone, :uuid, :reward]}
  schema "habit_completion_reward" do
    field :taken_at_local, :naive_datetime
    field :local_timezone, :string
    field :uuid, Ecto.ShortUUID, autogenerate: true
    

    belongs_to :reward, Reward
    belongs_to :habit_completion, HabitCompletion

    timestamps()
  end

  @doc false
  def changeset(habit_completion_reward, attrs) do
    habit_completion_reward
    |> cast(attrs, [:reward_id, :habit_completion_id, :taken_at_local, :local_timezone])
    |> validate_required([:reward_id, :habit_completion_id])
    |> foreign_key_constraint(:reward_id)
    |> foreign_key_constraint(:habit_completion_id)
  end
end
