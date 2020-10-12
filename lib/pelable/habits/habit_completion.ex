defmodule Pelable.Habits.HabitCompletion do
  use Ecto.Schema
  import Ecto.Changeset
  alias Pelable.Habits.Streak

  @derive {Jason.Encoder, only: [:created_at_local_datetime, :local_timezone]}
  schema "habit_completion" do
    field :created_at_local_datetime, :naive_datetime
    field :local_timezone, :string

    belongs_to :streak, Streak
    timestamps()
  end

  @doc false
  def changeset(habit_completion, attrs) do
    habit_completion
    |> cast(attrs, [:streak_id, :created_at_local_datetime, :local_timezone])
    |> validate_required([:streak_id, :created_at_local_datetime, :local_timezone])
    |> foreign_key_constraint(:streak_id)
  end
end
