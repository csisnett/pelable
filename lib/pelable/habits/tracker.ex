defmodule Pelable.Habits.Tracker do
  use Ecto.Schema
  import Ecto.Changeset
  alias Pelable.Users.User

  schema "trackers" do
    field :name, :string
    field :uuid, Ecto.ShortUUID, autogenerate: true
    
    belongs_to :tracking_user, User
    timestamps()
  end

  @doc false
  def changeset(tracker, attrs) do
    tracker
    |> cast(attrs, [:name, :tracking_user_id])
    |> validate_required([:name, :tracking_user_id])
    |> foreign_key_constraint(:tracking_user_id)
  end
end
