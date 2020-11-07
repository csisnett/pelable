defmodule Pelable.Habits.Reminder do
  use Ecto.Schema
  import Ecto.Changeset

  @repetition_days ["monday", "tuesday", "wednesday", "thursday", "friday", "saturday", "sunday"]
  @frequency_options ["secondly", "minutely", "hourly", "daily", "weekly", "monthly", "yearly"]
  # To detect if is recurrent or not use time_frequency == nil

  schema "reminders" do
    field :name, :string
    field :uuid, Ecto.ShortUUID, autogenerate: true
    field :local_timezone, :string
    field :active?, :boolean, default: true # When creating a new one is automatically active
    field :time_start, :time
    field :time_start_string, :string, virtual: true
    field :date_start, :date #Can be used for recurrent or one off. If not recurrent this is the only date the reminder will go off
    field :date_end, :date
    field :repeat_on_days, {:array, :string} # When time_frequency == "weekly", they may choose specific days
    field :time_frequency, :string
    field :frequency_interval, :integer # this + time_frequency determines the time between recurrent reminders
    belongs_to :creator, User
    timestamps()
  end


  def recurrent_changeset(reminder, attrs) do
    reminder
    |> cast(attrs,[:name, :local_timezone, :time_start, :date_start, :creator_id, :active?,
    :date_end, :repeat_on_days, :time_frequency, :frequency_interval])
    |> validate_required([:name, :local_timezone, :time_start, :date_start, :creator_id, :active?, :time_frequency])
    |> foreign_key_constraint(:creator_id)
  end

  @doc false
  def changeset(reminder, attrs) do
    reminder
    |> cast(attrs,[:name, :local_timezone, :time_start, :date_start, :creator_id, :active?,
    :date_end, :repeat_on_days, :time_frequency, :frequency_interval])
    |> validate_required([:name, :local_timezone, :time_start, :date_start, :creator_id, :active?])
    |> foreign_key_constraint(:creator_id)
  end
end
