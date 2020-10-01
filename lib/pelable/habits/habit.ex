defmodule Pelable.Habits.Habit do
  use Ecto.Schema
  import Ecto.Changeset

  schema "habits" do

    field :name, :string
    field :time_frequency, :string
    field :archived?, :boolean, default: false
    field :uuid, Ecto.ShortUUID, autogenerate: true

    belongs_to :user, User
    timestamps()
  end

  @doc false
  def changeset(habit, attrs) do
    habit
    |> cast(attrs, [:name, :time_frequency, :archived?, :user_id])
    |> validate_required([:name, :time_frequency, :user_id])
    |> foreign_key_constraint(:user_id)
  end
end
