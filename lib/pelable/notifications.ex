defmodule Pelable.Notifications do

    import Ecto.Query, warn: false
    alias Pelable.Repo

    alias Pelable.Chat.{Chatroom, Message, LastConnection, Invitation, Participant, Mention}
    alias Pelable.Learn
    alias Pelable.Users.User
    alias Pelable.Chat
    alias PelableWeb.PowMailer
    alias Pelable.Chat.LastEmail

    def get_last_email(%User{} = user) do
        query = from le in LastEmail, where: le.user_id == ^user.id
        Repo.one(query)
    end

    def create_last_email(%User{} = user) do
        attrs = %{"user_id" => user.id}
        LastEmail.changeset(%LastEmail{}, attrs) |> Repo.insert
    end

    def update_last_email(%User{} = user) do
        case get_last_email(user) do
          nil -> create_last_email(user)
          last_email ->
            now = DateTime.utc_now
            LastEmail.changeset(last_email, %{"updated_at" => now}) |> Repo.update
        end
    end

    def unread_messages(%Chatroom{} = chatroom, %User{} = user) do
        last_connection = Chat.get_last_connection(user, chatroom)
        case last_connection do
            nil -> 
                count = Repo.all(from m in Message, where: m.chatroom_id == ^chatroom.id) |> Enum.count
                {chatroom, count, user}
            last_connection ->
            count = Repo.all(from m in Message, where: m.chatroom_id == ^chatroom.id and m.inserted_at > ^last_connection.updated_at, select: m.id) |> Enum.count
            {chatroom, count, user}
        end
    end

    def only_unread_messages(chatroom_count) when is_list(chatroom_count) do
        Enum.filter(chatroom_count, fn tuple ->  elem(tuple, 1) != 0 end)
    end

    def unread_messages(%User{} = user) do
        user = Repo.preload(user, [:joined_chats])
        Enum.map(user.joined_chats, fn chatroom -> unread_messages(chatroom, user) end) |> only_unread_messages
    end

    def new_message_string(tuple, acc) do
        {chatroom, count, user} = tuple
        chatroom = Repo.preload(chatroom, [:participants])
        from = if chatroom.type == "private conversation" do
            "<b>" <> "@" <> Chat.get_recipient(user, chatroom.participants) <> "</b>"
        else
            chatroom.name
        end
        chat_url = "https://pelable.com/chat/" <> chatroom.uuid
        acc <> Integer.to_string(count) <> "<a href=#{inspect chat_url}> new messages </a>" <> "from " <> from <> "<br>"
    end

    def send_unread_notification_email(%User{} = user) do
        case unread_messages(user) do
            [] -> :no_messages
            chatrooms ->
                content = Enum.reduce(chatrooms, "", fn tuple, acc -> new_message_string(tuple, acc) end)
                PowMailer.send_to_user(user, %{"subject" => "You have new messages", "html" => content, "text" => HtmlSanitizeEx.strip_tags(content)})
        end
    end



end