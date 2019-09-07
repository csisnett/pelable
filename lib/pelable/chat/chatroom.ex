defmodule Pelable.Chat.Chatroom do
  use Ecto.Schema
  import Ecto.Changeset

  alias Pelable.Users.User

  schema "chatrooms" do
    field :description, :string
    field :name, :string
    field :topic, :string
    field :uuid, :string
    belongs_to :creator, User

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
    |> cast(attrs, [:uuid, :description, :name, :topic, :creator_id])
    |> validate_required([:uuid, :description, :name, :topic, :creator_id])
    |> generate_uuid
    |> unique_constraint(:uuid)
  end
end
