defmodule Pelable.Learn.Task do
  use Ecto.Schema
  import Ecto.Changeset

  alias Pelable.Learn.Task.{NameSlug}

  @valid_status ["finished", "not started", "in progress"]
  @derive {Jason.Encoder, only: [:name, :status, :uuid, :slug]}
  schema "tasks" do
    field :name, :string
    field :status, :string, default: "not started"
    field :uuid, Ecto.ShortUUID, autogenerate: true
    field :slug, NameSlug.Type
    belongs_to :creator, User

    timestamps()
  end

  def validate_status(changeset) do
    {_, status} = fetch_field(changeset, :status)
    case Enum.member?(@valid_status, status) do
      true -> changeset
      false -> add_error(changeset, :status, "Not a valid status")
    end
  end

  @doc false
  def changeset(task, attrs) do
    task
    |> cast(attrs, [:name, :status, :creator_id])
    |> validate_required([:name, :status, :creator_id])
    |> foreign_key_constraint(:creator_id)
    |> NameSlug.maybe_generate_slug
    |> validate_status
  end
end
