defmodule Pelable.Learn.Workspace do
  use Ecto.Schema
  import Ecto.Changeset

  alias Pelable.Users.User
  alias Pelable.Chat.Chatroom
  alias Pelable.Learn.{NameSlug}

  schema "workspaces" do
    field :name, :string
    field :uuid, Ecto.ShortUUID, autogenerate: true
    field :slug, NameSlug.Type
    field :personal?, :boolean, default: false
    
    belongs_to :creator, User
    belongs_to :chatroom, Chatroom
    timestamps()

  end

  @doc false
  def changeset(workspace, attrs) do
    workspace
    |> cast(attrs, [:name, :creator_id, :chatroom_id, :personal?])
    |> validate_required([:name, :creator_id, :chatroom_id])
    |> unique_constraint(:uuid)
    |> foreign_key_constraint(:creator_id)
    |> foreign_key_constraint(:chatroom_id)
    |> NameSlug.maybe_generate_slug
  end
end
