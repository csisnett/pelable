defmodule Pelable.Chat.Message do
  use Ecto.Schema
  import Ecto.Changeset

  alias Pelable.Users.User
  alias Pelable.Chat.{Message, Chatroom}

  schema "messages" do
    field :body, :string
    field :uuid, Ecto.ShortUUID, autogenerate: true

    belongs_to :sender, User
    belongs_to :chatroom, Chatroom
    belongs_to :parent, Message

    timestamps()
  end

  @doc false
  def changeset(message, attrs) do
    message
    |> cast(attrs, [:body, :sender_id, :chatroom_id, :parent_id])
    |> validate_required([:body, :sender_id, :chatroom_id])
    |> unique_constraint(:uuid)
  end
end
