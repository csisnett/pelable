defmodule Pelable.Batches do
    
    import Ecto.Query, only: [from: 2]
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
        Chat.list_messages_by_chatroom(id) |> Repo.all
        |> Enum.map(fn m -> get_user_from_message(m) end)
        |> Enum.uniq
    end

    def get_all_messages(username, chatroom_id) do
        user = Repo.get_by(User, username: username)
        query = from m in Message, where: m.sender_id == ^user.id and m.chatroom_id == ^chatroom_id
        Repo.all(query) 
    end

    #To make and destroy Teams

    def convert_usernames(users) when is_list(users) do
        Enum.map(users, fn username -> Repo.get_by(User, username: username) end)
    end

    def new_team_request(%User{} = user, %Chatroom{} = chatroom) do
      event = user.username <> " aka " <> user.email <> " invitation for " <> chatroom.name <> " has expired and wants to join a new team"
      PowMailer.send_admin(%{"text" => event, "html" => event, "subject" => "New team request from "<> user.username})
    end

    #Used for November Batch
    def create_invitation_team(team_name) do
        chatroom = Chat.create_team_chatroom(%{"creator_id" => 1, "name" => team_name})
        Chat.add_participant("csisnett", chatroom.uuid)
        chatroom
    end

    # Used this for October Batch
    # [username, ..., username], String -> %Chatroom{"type" => "private group", ""}
    # Takes a list of usernames and join the respective users to a new chatroom.
    def create_team_chat(user_list, team_name) when is_list(user_list) do
        user_list = convert_usernames(user_list)
        chatroom = Chat.create_chatroom_assoc(%{"type" => "private group team", "creator_id" => 1, "name" => team_name}) |> Repo.preload([:participants])
        chatroom_changeset = Ecto.Changeset.change(chatroom)
        chatroom_participants_changeset = chatroom_changeset |> Ecto.Changeset.put_assoc(:participants, user_list)
        Repo.update!(chatroom_participants_changeset)
    end

    def add_user_to_team(%User{} = user, %Chatroom{} = chatroom) do
        chatroom = chatroom |> Repo.preload([:participants])
        case Chat.add_participant(user, chatroom) do
            {:ok, _participant} -> create_directs_for_user(user, chatroom.participants)
        end
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

    def dead_users do
        users = Learn.list_users
        ch = Repo.get_by(Chatroom, uuid: "c3EMBSqNzdRo")
        Enum.filter(users, fn s ->  Chat.get_last_connection(s, ch) == nil end)
    end

    # To Monitor Team's healthy levels

    def dead_teams do
        ["l-ZMHysu53l4", "zxuH2TaMc2tE"] |> Enum.map(fn uuid -> Repo.get_by(Chatroom, uuid: uuid) end)
    end

    def chatting_teams do
        ["Zq6_2V3qXvIV", "pGuZzdqXsxk8"]
    end

    def teams do
        ["dl5Q0m8kP3LH", "d_j7_FvMSfzc", "BaQVRKH3N-wW", "o6WVZQS9xROL",
         "OWib6Zf8d1xs", "mavvVf1eT4sV", "pGuZzdqXsxk8", "22LCrDBCS1wz", "Zq6_2V3qXvIV",
        "zxuH2TaMc2tE"]
        |> Enum.map(fn uuid -> Repo.get_by(Chatroom, uuid: uuid) end)
    end

    def time_since_last_message_sent(%User{} = user, time_now) do
        last_message = last_message_sent(user)
        time_in_seconds = NaiveDateTime.diff(time_now,last_message.inserted_at)
    end

    def interpret_teams_status(team_status_list) when is_list(team_status_list) do
        case length(team_status_list) do
            0 -> []
            x -> 
                [team_status | rest] = team_status_list
                participants_status = Enum.map(team_status["participants_status"], fn user_status -> interpret_user_status(user_status) end)
                team_status = Map.put(team_status, "participants_status", participants_status)
                team_status = interpret_one_team_status(team_status)
                [team_status | interpret_teams_status(rest)]
        end
    end

    def interpret_one_team_status(team_status) do
        team_status |> interpret_time_since_last_team_message
    end

    def interpret_time_since_last_team_message(team_status) do
        if team_status["time_since_last_team_message"] < 86400 do
            team_status |> Map.put("last_team_message_observation", "active team last message in the last 24 hours")
        else
            team_status |> Map.put("last_team_message_observation",  "inactive team last message more than 24 hours ago")
        end
    end

    def interpret_user_status(%{} = user_status) do
        user_status |> interpret_time_since_last_connection |> interpret_time_since_last_message_sent
    end

    def interpret_time_since_last_connection(%{} = user_status) do
        if user_status["time_since_last_connection"] < 172800 do
            user_status |> Map.put("last_connection_observation", "active last connection under 2 days")
        else
            user_status |> Map.put("last_connection_observation", "inactive last connection over 2 days ago")
        end
    end

    def interpret_time_since_last_message_sent(%{} = user_status) do
        if user_status["time_since_last_message_sent"] < 86400 do
            user_status |> Map.put("last_message_sent_observation", "active last message in the last 24 hours")
        else
            user_status |> Map.put("last_message_sent_observation",  "inactive last message more than 24 hours ago")
        end
    end

    def teams_status(team_chats) when is_list(team_chats) do
        case length(team_chats) do
        0 -> []
        x ->
        [chatroom | rest] = team_chats
        chatroom = chatroom |> Repo.preload([:participants])
        participants = chatroom.participants |> Enum.filter(fn user -> user.id != 1 end)
        time_now = NaiveDateTime.utc_now
        participants_status = Enum.map(participants, fn user ->
        %{"username" => user.username, "time_since_last_message_sent" => time_since_last_message_sent(user, time_now),
        "email" =>  user.email, "time_since_last_connection" => time_since_last_connection(user, time_now)} end)
        team_status = %{"team name" => chatroom.name, "time_since_last_team_message" => time_since_last_team_message(chatroom, time_now), "chat uuid" => chatroom.uuid, "participants_status" => participants_status}
        [team_status | teams_status(rest)] 
        end
    end

    # user -> [%{"chatroom name" => "Date/time"}, ...]
    def get_last_connections(%User{} = user) do
        user = user |> Repo.preload([:joined_chats, :chat_connections])
        last_connections = Enum.map(user.joined_chats, fn chatroom -> %{chatroom.name => Chat.get_last_connection(user, chatroom)} end)
    end

    def last_message_sent(%User{} = user) do
        query = from m in Message, where: m.sender_id == ^user.id, order_by: [desc: m.id], limit: 1
        Repo.one(query)
    end

    def time_since_last_connection(%User{} = user, time_now) do
        last_connection = get_last_last_connection(user)
        time_since_last_connection(last_connection, time_now)
    end

    def time_since_last_connection(%LastConnection{} = last_connection, time_now) do
        time_in_seconds = NaiveDateTime.diff(time_now,last_connection.updated_at)
    end

    def get_last_last_connection(%User{} = user) do
        query = from lc in LastConnection, where: lc.user_id == ^user.id, order_by: [desc: lc.updated_at], limit: 1
        Repo.one(query)
    end

    def get_last_last_connection(username) do
        user = Repo.get_by(User, username: username)
        get_last_last_connection(user)
    end

    def time_since_last_team_message(%Chatroom{} = chatroom, time_now) do
        message = get_last_message(chatroom)
        time_in_seconds = NaiveDateTime.diff(time_now, message.inserted_at)
    end

    def get_last_message(%Chatroom{} = chatroom) do
        Chat.get_last_message(chatroom)
    end

    def get_messages_until_date(%Chatroom{} = chatroom, %Date{} = date) do
        chatroom
    end

    def momentum_for_date(%Chatroom{} = chatroom, %Date{} = date) do
        messages = get_messages_for_date(chatroom, date)
        messages |> Enum.count
        |> case  do
        0 -> "no messages sent"
        1 -> "only one message sent"
        x ->
        {total_responses, average_response_time} = average_response_time(messages)
        average_response_time = average_response_time/3600 #convert seconds to hour
        momentum = total_responses/average_response_time
        end
    end

    def momentum_for_date(uuid, %Date{} = date) do
        chatroom = Repo.get_by(Chatroom, uuid: uuid)
        momentum_for_date(chatroom, date)
    end

    def average_response_time(messages) when is_list(messages) do
        total_responses = total_responses(messages, 0)
        total_responses_time = total_responses_time(messages)
        average_response_time = total_responses_time/total_responses
        {total_responses, average_response_time}
    end

    def total_responses(messages, count) when is_list(messages) do
        case length(messages) do
            1 -> count
            x ->
            [first_message, second_message| rest] = messages
            if response?(first_message, second_message) do
                total_responses([second_message | rest], count + 1)
            else
                total_responses([second_message | rest], count)
            end
        end
    end

    def total_responses_time(messages) when is_list(messages) do
        case length(messages) do
        2 ->
            [first_message, second_message| rest] = messages
            if response?(first_message, second_message) do
            NaiveDateTime.diff(second_message.inserted_at, first_message.inserted_at)
            else
                0
            end
        x ->
            [first_message, second_message| rest] = messages

            total_time = if response?(first_message, second_message) do
            NaiveDateTime.diff(second_message.inserted_at, first_message.inserted_at)
            else
                0
            end
            total_time + total_responses_time([second_message | rest])
        end
    end

    def response?(%Message{} = first_message, %Message{} = second_message) do
        first_message.sender_id != second_message.sender_id
    end

    def get_messages_for_date(%Chatroom{} = chatroom, %Date{} = date) do
        {:ok, datetime} = NaiveDateTime.new(date.year, date.month, date.day, 0,0,0)
        second_day = NaiveDateTime.add(datetime, 86400)
        query = from m in Message, where: m.chatroom_id == ^chatroom.id and m.inserted_at >= ^datetime and m.inserted_at <= ^second_day, order_by: [asc: m.inserted_at]
        Repo.all(query) 
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