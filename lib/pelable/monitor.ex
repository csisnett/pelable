defmodule Pelable.Monitor do

    import Ecto.Query, only: [from: 2]
    alias Pelable.Repo

    alias Pelable.Learn
    alias Pelable.Users.User
    alias Pelable.Chat
    alias PelableWeb.PowMailer
    alias Pelable.Batches
    alias Pelable.Chat.{Chatroom, Message, LastConnection, Invitation, Mention}

  # To Monitor Team's healthy levels

    def convert_to_chatroom(team_list) when is_list(team_list) do
        team_list |> Enum.map(fn uuid -> Repo.get_by(Chatroom, uuid: uuid) end)
    end

    def dead_teams do
        ["l-ZMHysu53l4", "zxuH2TaMc2tE"] |> convert_to_chatroom
    end

    def chatting_teams do
        ["Zq6_2V3qXvIV", "pGuZzdqXsxk8"]
    end

    def teams do
        ["dl5Q0m8kP3LH", "d_j7_FvMSfzc", "BaQVRKH3N-wW", "o6WVZQS9xROL",
        "OWib6Zf8d1xs", "mavvVf1eT4sV", "pGuZzdqXsxk8", "22LCrDBCS1wz", "Zq6_2V3qXvIV",
        "zxuH2TaMc2tE"]
        |> convert_to_chatroom
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


end