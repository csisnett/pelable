defmodule PelableWeb.ChatroomView do
  alias Pelable.Chat
  use PelableWeb, :view
  alias Pelable.Chat.Message
  alias Pelable.Users.User
  alias Pelable.Chat.Chatroom

  def old_messages(user, chatroom) do
    last_connection = Chat.get_last_connection(user, chatroom)
    case last_connection do
      nil -> Chat.list_messages_by_chatroom(chatroom.id)
      last_connection ->
    Chat.list_messages_before_datetime(chatroom.id, last_connection.updated_at)
    end
  end

  def last_connection(user, chatroom) do
    Chat.get_last_connection(user, chatroom)
  end

  def new_messages(user, chatroom) do
    last_connection = Chat.get_last_connection(user, chatroom)
    Chat.list_messages_after_datetime(chatroom.id, last_connection.updated_at)
  end

  def seen_last_message?(user, chatroom) do
    Chat.seen_last_message?(user, chatroom)
  end

  def get_recipient(%User{} = user, participants) when is_list(participants) do
    case length(participants) do
    1 -> user.username
    x -> 
    recipient = Enum.filter(participants, fn recipient -> user.username != recipient.username end) |> Enum.at(0)
    recipient.username
    end
  end

  def render_private_conversation(%User{} = user, %Chatroom{} = chatroom, path) do
    content_tag(:a, get_recipient(user, chatroom.participants), chatroom_uuid: chatroom.uuid, href: path)
  end

  def get_private_conversations(user) do
    Chat.get_private_conversations(user, "private conversation")
  end

  def get_private_groups(user) do
    Chat.get_conversations(user, "private group")
  end

  def render_message(%Message{} = message) do
    {:safe, datetime} = content_tag(:datetime, message.inserted_at)
    username_raw = message.sender.username <> ": "
    username_escaped = username_raw |> html_escape |> safe_to_string
    {:safe, username} = content_tag(:b, username_escaped)
    {:safe, escaped_body} = html_escape(message.body)
    {safe, body} = content_tag(:message, escaped_body)
    # <p> <datetime> datetime </datetime> username <message> body </message> </p>
    {:safe, [60, "p", [], 62, datetime, " ", username, body, 60, 47, "p", 62]}
  end

  

  def description?(nil) do
    false
  end

  def description?(description) do
    true
  end
end
