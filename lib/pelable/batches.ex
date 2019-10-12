defmodule Pelable.Batches do
    
    import Ecto.Query, warn: false
    alias Pelable.Repo

    alias Pelable.Chat.{Chatroom, Message, LastConnection, Invitation}
    alias Pelable.Learn
    alias Pelable.Users.User
    alias Pelable.Chat
    alias PelableWeb.PowMailer

    def get_user_from_message(%Message{} = message) do
        Learn.get_user!(message.sender_id)
    end

    def list_users_in_batch(id) do
        Chat.list_messages_by_chatroom(id)
        |> Emum.map(fn m -> get_user_from_message(m) end)
        |> Enum.uniq
    end

    def get_all_messages(%User{} = user, chatroom_id) do
        query = from m in Message, where: m.sender_id == ^user.id and m.chatroom_id == ^chatroom_id
        Repo.all(query) 
    end

    def dead_users do
        users = Learn.list_users
        ch = Repo.get_by(Chatroom, uuid: "c3EMBSqNzdRo")
        Enum.filter(users, fn s ->  Chat.get_last_connection(s, ch) == nil end)
    end

end