defmodule PelableWeb.ChatroomView do
  alias Pelable.Chat
  use PelableWeb, :view
  alias Pelable.Chat.Message
  alias Pelable.Users.User
  alias Pelable.Chat.Chatroom

  def seen_last_message?(user, chatroom) do
    Chat.seen_last_message?(user, chatroom)
  end

  def filter_other_than(%User{} = user, users) do
    [first_user | rest] = users
    if first_user == user do
      [other_user | empty] = rest
      other_user.username
    else
      first_user.username
    end
  end

  def render_private_conversation(%User{} = user, %Chatroom{} = chatroom, path) do
    content_tag(:a, filter_other_than(user, chatroom.participants), chatroom_uuid: chatroom.uuid, href: path)
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
    # <p <datetime> datetime </datetime> username <message> body </message> </p>
    {:safe, [60, "p", [], 62, datetime, " ", username, body, 60, 47, "p", 62]}
  end

  

  def description?(nil) do
    false
  end

  def description?(description) do
    true
  end
end
