defmodule Pelable.Learn.Workspace do
  use Ecto.Schema
  import Ecto.Changeset

  alias Pelable.Users.User
  alias Pelable.Chat.Chatroom
  alias Pelable.Learn.{NameSlug}

  schema "workspaces" do
    field :name, :string
    field :type, :string, default: "public"
    field :uuid, Ecto.ShortUUID, autogenerate: true
    field :slug, NameSlug.Type

    belongs_to :creator, User
    belongs_to :chatroom, Chatroom
    timestamps()

  end

  @doc false
  def changeset(workspace, attrs) do
    workspace
    |> cast(attrs, [:name, :type, :creator_id, :chatroom_id])
    |> validate_required([:name, :type, :creator_id, :chatroom_id])
    |> unique_constraint(:uuid)
    |> foreign_key_constraint(:creator_id)
    |> foreign_key_constraint(:chatroom_id)
    |> NameSlug.maybe_generate_slug
  end
end
