defmodule Pelable.Learn.Resource do
  use Ecto.Schema
  import Ecto.Changeset

  schema "resources" do
    field :url, :string
    field :uuid, Ecto.ShortUUID, autogenerate: true
    
    belongs_to :creator, User
    timestamps()
  end

  @doc false
  def changeset(resource, attrs) do
    resource
    |> cast(attrs, [:url, :creator_id])
    |> validate_required([:url, :creator_id])
    |> unique_constraint(:uuid)
    |> unique_constraint(:url)
    |> foreign_key_constraint(:creator_id)
  end
end
