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

    timestamps()
  end

  @doc false
  def changeset(message, attrs) do
    message
    |> cast(attrs, [:body, :sender_id, :chatroom_id])
    |> validate_required([:body, :sender_id, :chatroom_id])
    |> unique_constraint(:uuid)
    |> foreign_key_constraint(:chatroom_id)
    |> foreign_key_constraint(:sender_id)
  end
end
