defmodule Pelable.Learn.Bookmark do
  use Ecto.Schema
  import Ecto.Changeset

  alias Pelable.Users.User
  alias Pelable.Learn.Resource

  schema "bookmarks" do
    field :title, :string
    field :uuid, Ecto.ShortUUID, autogenerate: true

    belongs_to :creator, User
    belongs_to :resource, Resource
    timestamps()
  end

  @doc false
  def changeset(bookmark, attrs) do
    bookmark
    |> cast(attrs, [:title, :creator_id, :resource_id])
    |> validate_required([:creator_id, :resource_id])
    |> foreign_key_constraint(:creator_id)
    |> foreign_key_constraint(:resource_id)
  end
end

