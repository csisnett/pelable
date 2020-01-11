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

    # [String, ...] -> %User{}
    # Takes a list of usernames and returns a list of %User{}
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
            {:ok, _participant} -> 
                create_directs_for_user(user, chatroom.participants)
                url = "https://pelable.com/chat/" <> chatroom.uuid
                text = user.username <> " just joined" <> chatroom.name <> "🎉\n Welcome them into the team😊"
                html = "<b>" <> user.username <> "</b>" <> " just joined " <> chatroom.name <> "🎉" <> "<br>" <> "<a href=#{url}> Welcome </a> them into the team😊"
                message = %{"subject" => user.username <> " joined your team!", "text" => text, "html" => html}
                Enum.each(chatroom.participants, fn user -> PowMailer.send_to_user(user, message)end)

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