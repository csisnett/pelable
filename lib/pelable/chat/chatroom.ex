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

  @doc false
  def changeset(chatroom, attrs) do
    chatroom
    |> cast(attrs, [:uuid, :description, :name, :topic, :creator_id])
    |> validate_required([:uuid, :description, :name, :topic, :creator_id])
    |> unique_constraint(:uuid)
  end
end
