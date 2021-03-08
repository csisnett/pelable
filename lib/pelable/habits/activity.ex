defmodule Pelable.Habits.Activity do
  use Ecto.Schema
  import Ecto.Changeset

  alias Pelable.Habits.Tracker

  @derive {Jason.Encoder, only: [:name, :uuid, :started_at_local, :terminated_at_local, :local_timezone]}
  schema "activities" do
    field :name, :string
    field :uuid, Ecto.ShortUUID, autogenerate: true
    field :started_at_local, :naive_datetime
    field :terminated_at_local, :naive_datetime
    field :local_timezone, :string
    belongs_to :tracker, Tracker
    timestamps()
  end

  @doc false
  def changeset(activity, attrs) do
    activity
    |> cast(attrs, [:name, :started_at_local, :terminated_at_local, :tracker_id, :local_timezone])
    |> validate_required([:name, :started_at_local, :tracker_id, :local_timezone])
    |> foreign_key_constraint(:tracker_id)
  end
end
