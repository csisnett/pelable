defmodule Pelable.Habits.StreakSaver do
  use Ecto.Schema
  import Ecto.Changeset
  alias Pelable.Users.User
  alias Pelable.Habits.Streak

  schema "streak_saver" do
    field :start_date, :date
    field :end_date, :date

    belongs_to :streak, Streak
    belongs_to :creator, User
    timestamps()
  end

  @doc false
  def changeset(streak_saver, attrs) do
    streak_saver
    |> cast(attrs, [:start_date, :end_date])
    |> validate_required([:start_date, :end_date])
    |> foreign_key_constraint(:streak_id)
    |> foreign_key_constraint(:creator_id)
  end
end
