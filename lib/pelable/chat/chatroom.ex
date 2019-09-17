defmodule Pelable.Chat.Chatroom do
  use Ecto.Schema
  import Ecto.Changeset

  alias Pelable.Users.User

  @types ["public", "private group", "private conversation"]
  
  schema "chatrooms" do
    field :name, :string
    field :subject, :string
    field :description, :string
    field :type, :string, default: "public"
    
    field :uuid, :string
    belongs_to :creator, User
    many_to_many :participants, User, join_through: "chatroom_participant"
    many_to_many :invitations, User, join_through: "chatroom_invitations"
    timestamps()
  end

  def generate_random_uuid(length) do
    :crypto.strong_rand_bytes(length) |> Base.url_encode64 |> binary_part(0, length)
  end

  def generate_uuid(changeset) do
    case get_field(changeset, :uuid) do
      nil -> changeset |> put_change(:uuid, generate_random_uuid(12))
      _ -> changeset
    end
  end

  @doc false
  def changeset(chatroom, attrs) do
    chatroom
    |> cast(attrs, [:uuid, :description, :subject, :name, :creator_id, :type])
    |> validate_required([:name, :creator_id, :type])
    |> generate_uuid
    |> unique_constraint(:uuid)
    |> foreign_key_constraint(:creator_id)
  end
end
