defmodule Pelable.Batches do
    
    import Ecto.Query, warn: false
    alias Pelable.Repo

    alias Pelable.Chat.{Chatroom, Message, LastConnection, Invitation}
    alias Pelable.Learn
    alias Pelable.Users.User
    alias Pelable.Chat
    alias PelableWeb.PowMailer

    #To Match users

    def get_user_from_message(%Message{} = message) do
        Learn.get_user!(message.sender_id)
    end

    def list_users_in_batch(id) do
        Chat.list_messages_by_chatroom(id)
        |> Enum.map(fn m -> get_user_from_message(m) end)
        |> Enum.uniq
    end

    def get_all_messages(username, chatroom_id) do
        user = Repo.get_by(User, username: username)
        query = from m in Message, where: m.sender_id == ^user.id and m.chatroom_id == ^chatroom_id
        Repo.all(query) 
    end

    #To make Teams

    # [username, ..., username], String -> %Chatroom{"type" => "private group", ""}
    # Takes a list of usernames and join the respective users to a new chatroom.
    def create_team_chat(user_list, team_name) when is_list(user_list) do
        user_list = Enum.map(user_list, fn username -> Repo.get_by(User, username: username) end)
        chatroom = Chat.create_chatroom_assoc(%{"type" => "private group", "creator_id" => 1, "name" => team_name}) |> Repo.preload([:participants])
        chatroom_changeset = Ecto.Changeset.change(chatroom)
        chatroom_participants_changeset = chatroom_changeset |> Ecto.Changeset.put_assoc(:participants, user_list)
        Repo.update!(chatroom_participants_changeset)
    end

    def dead_users do
        users = Learn.list_users
        ch = Repo.get_by(Chatroom, uuid: "c3EMBSqNzdRo")
        Enum.filter(users, fn s ->  Chat.get_last_connection(s, ch) == nil end)
    end

end