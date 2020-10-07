defmodule Pelable.Habits.Reward do
  use Ecto.Schema
  import Ecto.Changeset

  alias Pelable.Habits.Reward.{NameSlug}

  schema "rewards" do
    field :name, :string
    field :description, :string
    field :archived?, :boolean, default: false
    field :uuid, Ecto.ShortUUID, autogenerate: true
    field :slug, NameSlug.Type
    belongs_to :creator, User

    timestamps()
  end

  

  @doc false
  def changeset(reward, attrs) do
    reward
    |> cast(attrs, [:name, :creator_id, :archived?, :description])
    |> validate_required([:name, :creator_id, :archived?])
    |> NameSlug.maybe_generate_slug
  end
end
