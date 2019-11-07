defmodule PelableWeb.ChatroomView do
  alias Pelable.Chat
  use PelableWeb, :view
  alias Pelable.Chat.Message
  alias Pelable.Users.User
  alias Pelable.Chat.Chatroom
  alias Pelable.Repo

  def able_to_join?(%Chatroom{} = chatroom) do
    DateTime.compare(chatroom.expires_at, DateTime.utc_now) == :gt
  end

  def participant?(%Chatroom{} = chatroom, %User{} = user) do
    Enum.any?(chatroom.participants, fn participant -> participant.id == user.id end)
  end

  def show_joining_prompt?(%Chatroom{} = chatroom, %User{} = user) do
    case chatroom.type do
      "private group team" -> able_to_join?(chatroom)
      _anything_else -> false
    end
  end

  def old_messages(user, chatroom) do
    last_connection = Chat.get_last_connection(user, chatroom)
    case last_connection do
      nil -> Chat.list_messages_by_chatroom(chatroom.id) |> Chat.get_mentions |> Repo.all
      last_connection ->
    Chat.list_messages_before_datetime(chatroom.id, last_connection.updated_at) |> Chat.get_mentions |> Repo.all
    end
  end

  def last_connection(user, chatroom) do
    Chat.get_last_connection(user, chatroom)
  end

  def new_messages(user, chatroom) do
    last_connection = Chat.get_last_connection(user, chatroom)
    Chat.list_messages_after_datetime(chatroom.id, last_connection.updated_at) |> Chat.get_mentions |> Repo.all
  end

  def seen_last_message?(user, chatroom) do
    Chat.seen_last_message?(user, chatroom)
  end

  def render_private_conversation(%User{} = user, %Chatroom{} = chatroom, path) do
    content_tag(:a, Chat.get_recipient(user, chatroom.participants), chatroom_uuid: chatroom.uuid, href: path)
  end

  def get_private_conversations(user) do
    Chat.get_private_conversations(user, "private conversation")
  end

  def get_private_groups(user) do
    Chat.get_conversations(user, "private group")
  end

  def create_message_element(%Message{} = message) do
    case message.mentions do
      [] -> content_tag(:message, message.body)
      x ->
        mentions_string = Enum.reduce(message.mentions,"", fn mention, acc -> mention.user.username <> " " <> acc end)
        content_tag(:message, message.body, mentions: mentions_string)
    end
  end

  def render_message(%Message{} = message) do
    {:safe, datetime} = content_tag(:datetime, message.inserted_at)
    username_raw = message.sender.username <> ": "
    username_escaped = username_raw |> html_escape |> safe_to_string
    {:safe, username} = content_tag(:b, username_escaped)
    {:safe, message_element} = create_message_element(message)
    # <p> <datetime> datetime </datetime> username <message if they exist mentions="csisnett "> body </message> </p>
    {:safe, [60, "p", [], 62, datetime, " ", username, message_element, 60, 47, "p", 62]}
  end

  

  def description?(nil) do
    false
  end

  def description?(description) do
    true
  end
end
