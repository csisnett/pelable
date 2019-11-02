defmodule Pelable.Chat.Chatroom do
  use Ecto.Schema
  import Ecto.Changeset

  alias Pelable.Users.User

  @types ["public", "private group", "private conversation", "private group team"]

  schema "chatrooms" do
    field :name, :string
    field :description, :string
    field :type, :string, default: "public"
    field :expires_at, :utc_datetime
    field :expired?, :boolean, default: false

    field :uuid, :string
    belongs_to :creator, User
    many_to_many :participants, User, join_through: "chatroom_participant"
    many_to_many :invited_users, User, join_through: "chatroom_invitation"
    many_to_many :connected_users, User, join_through: "last_connection"
    
    timestamps()
  end

  def new_random_uuid(length) do
    :crypto.strong_rand_bytes(length) |> Base.url_encode64 |> binary_part(0, length)
  end

  def generate_uuid(changeset) do
    case get_field(changeset, :uuid) do
      nil -> changeset |> put_change(:uuid, new_random_uuid(12))
      _ -> changeset
    end
  end

  #Expires 48 hours after its creation
  def new_expiration_date do
    DateTime.utc_now |> DateTime.add(86400 * 2) |> DateTime.truncate(:second)
  end

  def generate_expiration_date(changeset) do
    case get_field(changeset, :type) do
    "private group team" ->
      case get_field(changeset, :expires_at) do
      nil -> changeset |> put_change(:expires_at, new_expiration_date)
        _ -> changeset
      end
      _another_type -> changeset
  end
  end

  @doc false
  def changeset(chatroom, attrs) do
    chatroom
    |> cast(attrs, [:uuid, :description, :name, :creator_id, :type, :expires_at])
    |> validate_required([:name, :creator_id, :type])
    |> generate_uuid
    |> generate_expiration_date
    |> unique_constraint(:uuid)
    |> foreign_key_constraint(:creator_id)
  end
end
