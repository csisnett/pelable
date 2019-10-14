defmodule Pelable.Chat.Participant do
    use Ecto.Schema
    import Ecto.Changeset
  
    alias Pelable.Users.User
    alias Pelable.Chat.Chatroom

    schema "chatroom_participant" do
        belongs_to :chatroom, Chatroom
        belongs_to :user,  User
    end

    def changeset(participant, attrs) do
        participant
        |> cast(attrs, [:user_id, :chatroom_id])
        |> validate_required([:user_id, :chatroom_id])
    end
end