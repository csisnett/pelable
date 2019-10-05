defmodule PelableWeb.ChatroomView do
  alias Pelable.Chat
  use PelableWeb, :view
  alias Pelable.Chat.Message

  def seen_last_message?(user, chatroom) do
    Chat.seen_last_message?(user, chatroom)
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
