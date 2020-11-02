defmodule Pelable.Habits.Habit do
  use Ecto.Schema
  import Ecto.Changeset

  alias Pelable.Users.User
  alias Pelable.Habits.{Reward, Reminder, HabitReminder}

  @time_frequencies ["hourly", "daily", "weekly", "monthly", "quarterly"]
  schema "habits" do

    field :name, :string
    field :time_frequency, :string
    field :archived?, :boolean, default: false
    field :uuid, Ecto.ShortUUID, autogenerate: true
    field :complete_now?, :boolean, virtual: true

    belongs_to :current_reward, Reward
    belongs_to :user, User
    many_to_many :reminders, Reminder, join_through: "habit_reminder"
    has_many :habit_reminder, HabitReminder
    timestamps()
  end

  def validate_time_frequency(changeset) do
    {_, time_frequency} = fetch_field(changeset, :time_frequency)
    case Enum.member?(@time_frequencies, time_frequency) do
      true -> changeset
      false -> add_error(changeset, :time_frequency, "Not a valid time frequency")
    end
  end

  @doc false
  def changeset(habit, attrs) do
    habit
    |> cast(attrs, [:name, :time_frequency, :archived?, :user_id, :current_reward_id])
    |> validate_required([:name, :time_frequency, :user_id])
    |> validate_time_frequency
    |> foreign_key_constraint(:user_id)
    |> foreign_key_constraint(:current_reward_id)
  end
end
