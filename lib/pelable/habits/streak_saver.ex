defmodule Pelable.Habits.StreakSaver do
  use Ecto.Schema
  import Ecto.Changeset
  alias Pelable.Users.User
  alias Pelable.Habits.Streak
  alias Pelable.Habits

  # A streak saver allows a streak to remain alive from start_date to end_date
  # Users can still log habits during this period but it doesn't change the state of the streak saver
  # If a  user resumes a habit the end_date is changed to the present date. The start_date and end_date are inclusive.
  # This means that the streak is alive until end_date. If the user dodesn't log the habit the day after end_date then the streak dies.
  schema "streak_saver" do
    field :start_date, :date
    field :end_date, :date

    belongs_to :streak, Streak
    belongs_to :creator, User
    timestamps()
  end

  # %Date{}, String -> Boolean
  # Returns true if the date is in the present or the future of the timezone
  def is_date_in_the_future?(date, timezone) do
    local_date = Habits.create_local_present_datetime(timezone) |> DateTime.to_date
    case Date.compare(date, local_date) do
      :gt -> true # If the date is in the future is valid
      :eq -> true # If the same date it's valid
      :lt -> false # If the date is in the past is invalid
    end
  end


  def validate_start_date(changeset, timezone) do
    start_date = get_field(changeset, :start_date)
    case is_date_in_the_future?(start_date, timezone) do
      true -> changeset
      false -> add_error(changeset, :start_date, "Date is in the past of the given timezone")
    end
  end

  def validate_end_date(changeset, timezone) do
    end_date = get_field(changeset, :end_date)
    case is_date_in_the_future?(end_date, timezone) do
      true -> changeset
      false -> add_error(changeset, :end_date, "Date is in the past of the given timezone")
    end
  end

  @doc false
  def changeset(streak_saver, attrs) do
    streak_saver
    |> cast(attrs, [:start_date, :end_date, :streak_id, :creator_id])
    |> validate_required([:start_date, :end_date, :streak_id, :creator_id])
    |> validate_start_date(attrs["user_timezone"])
    |> validate_end_date(attrs["user_timezone"])
    |> foreign_key_constraint(:streak_id)
    |> foreign_key_constraint(:creator_id)
  end
end
