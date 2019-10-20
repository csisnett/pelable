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

    def create_directs_for_me(username) do
        user = Repo.get_by(User, username: username)
        me = Learn.get_user!(1)
        create_directs_for_user(user, [me])
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

    def teams do
        ["dl5Q0m8kP3LH", "d_j7_FvMSfzc", "BaQVRKH3N-wW", "o6WVZQS9xROL",
         "OWib6Zf8d1xs", "mavvVf1eT4sV", "pGuZzdqXsxk8", "22LCrDBCS1wz", "Zq6_2V3qXvIV",
        "l-ZMHysu53l4", "zxuH2TaMc2tE"]
        |> Enum.map(fn uuid -> Repo.get_by(Chatroom, uuid: uuid) end)
    end

    def user_status(%User{} = user) do
        case sent_in_a_day?(user) do
            true -> "active"
            false -> "inactive"
        end
    end

    def teams_status(team_chats) when is_list(team_chats) do
        case length(team_chats) do
        0 -> []
        x ->
        [chatroom | rest] = team_chats
        chatroom = chatroom |> Repo.preload([:participants])
        participants = chatroom.participants
        participants_status = Enum.map(participants, fn user -> %{"username" => user.username, "status" => user_status(user), "email" =>  user.email} end)
        team_status = %{"team name" => chatroom.name, "chat uuid" => chatroom.uuid, "members_status" => participants_status}
        [team_status | teams_status(rest)] 
        end
    end

    # user -> [%{"chatroom name" => "Date/time"}, ...]
    def get_last_connections(%User{} = user) do
        user = user |> Repo.preload([:joined_chats, :chat_connections])
        last_connections = Enum.map(user.joined_chats, fn chatroom -> %{chatroom.name => Chat.get_last_connection(user, chatroom)} end)
    end

    def sent_in_a_day?(%User{} = user) do
        case last_sent_message(user) do
        nil -> false
        message ->
        a_day_ago = NaiveDateTime.utc_now |> NaiveDateTime.add(-86_400, :second)
        NaiveDateTime.compare(message.inserted_at, a_day_ago) == :gt
        end
    end

    def last_sent_message(%User{} = user) do
        query = from m in Message, where: m.sender_id == ^user.id, order_by: [desc: m.id], limit: 1
        Repo.one(query)
    end

    def delete_all_participants(%Chatroom{} = chatroom) do
        chatroom = chatroom |> Repo.preload([:participants])
        chatroom.participants
        |> Enum.each(fn user -> Chat.delete_participant(chatroom, user) end)
    end

    def delete_all_participants(uuid) do
        chatroom = Repo.get_by(Chatroom, uuid: uuid)
        delete_all_participants(chatroom)
    end

    def delete_participants(participants, %Chatroom{} = chatroom) when is_list(participants) do
        participants
        |> Enum.each(fn user -> Chat.delete_participant(chatroom, user) end)
    end

    # Communication with teams

    def get_emails(%Chatroom{} = chatroom) do
      chatroom = chatroom |> Repo.preload([:participants])
      chatroom.participants
      |> Enum.map(fn user -> user.email end)
    end

    def get_emails(uuid) do
        chatroom = Repo.get_by(Chatroom, uuid: uuid)
        get_emails(chatroom)
    end

    def get_batch_emails(team_list) when is_list(team_list) do
        case length(team_list) do
        0 -> []
        x -> 
        [first | rest] = team_list
        emails = get_emails(first)
        emails ++ get_batch_emails(rest)
        end
    end

    def unique_batch_emails(team_list) when is_list(team_list) do
        get_batch_emails(team_list) |> Enum.uniq |> Enum.join(", ")
    end

end