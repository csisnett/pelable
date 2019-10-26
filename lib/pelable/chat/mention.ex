defmodule Pelable.Chat.Mention do
    use Ecto.Schema
    import Ecto.Changeset

    alias Pelable.Users.User
    alias Pelable.Chat.{Message, Chatroom}

    schema "message_mention" do
        belongs_to :message, Message
        belongs_to :user, User
    end

    def changeset(mention, attrs) do
        mention
        |> cast(attrs, [:user_id, :message_id])
        |> validate_required([:user_id, :message_id])
        |> unique_constraint(:user_id, name: :message_mention_user_id_message_id_index)
        |> unique_constraint(:message_id, name: :message_mention_user_id_message_id_index)
    end

end