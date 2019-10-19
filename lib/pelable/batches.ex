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

    def convert_usernames(users) when is_list(users) do
        Enum.map(users, fn username -> Repo.get_by(User, username: username) end)
    end

    # [username, ..., username], String -> %Chatroom{"type" => "private group", ""}
    # Takes a list of usernames and join the respective users to a new chatroom.
    def create_team_chat(user_list, team_name) when is_list(user_list) do
        user_list = convert_usernames(user_list)
        chatroom = Chat.create_chatroom_assoc(%{"type" => "private group", "creator_id" => 1, "name" => team_name}) |> Repo.preload([:participants])
        chatroom_changeset = Ecto.Changeset.change(chatroom)
        chatroom_participants_changeset = chatroom_changeset |> Ecto.Changeset.put_assoc(:participants, user_list)
        Repo.update!(chatroom_participants_changeset)
    end


    def create_directs_for_user(%User{} = user, user_list) when is_list(user_list) do
        case length(user_list) do
            0 -> :ok
            x ->
                [first | rest] = user_list
                two_users = [user, first]
                chatroom = Chat.create_chatroom_assoc(%{"type" => "private conversation", "creator_id" => 1, "name" => "Direct Message"}) |> Repo.preload([:participants])
                chatroom_changeset = Ecto.Changeset.change(chatroom)
                chatroom_participants_changeset = chatroom_changeset |> Ecto.Changeset.put_assoc(:participants, two_users)
                Repo.update!(chatroom_participants_changeset)
                create_directs_for_user(user, rest)

        end
    end

    def create_direct_chats(user_list) when is_list(user_list) do
        case length(user_list) do
           1 -> :ok
           x -> 
        
        [first | rest] = user_list
        create_directs_for_user(first, rest)
        create_direct_chats(rest)
        end
    end

    def dead_users do
        users = Learn.list_users
        ch = Repo.get_by(Chatroom, uuid: "c3EMBSqNzdRo")
        Enum.filter(users, fn s ->  Chat.get_last_connection(s, ch) == nil end)
    end

    # To Monitor Team's healthy levels

    def delete_all_participants(%Chatroom{} = chatroom) do
        chatroom = chatroom |> Repo.preload([:participants])
        chatroom.participants
        |> Enum.each(fn user -> Chat.delete_participant(chatroom, user) end)
    end

    def delete_participants(participants, %Chatroom{} = chatroom) when is_list(participants) do
        participants
        |> Enum.each(fn user -> Chat.delete_participant(chatroom, user) end)
    end

    def get_emails(%Chatroom{} = chatroom) do
      chatroom = chatroom |> Repo.preload([:participants])
      chatroom.participants
      |> Enum.map(fn user -> user.email end)
    end

    

end