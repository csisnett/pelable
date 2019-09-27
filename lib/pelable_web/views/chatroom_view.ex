defmodule PelableWeb.ChatroomView do
  alias Pelable.Chat
  use PelableWeb, :view
  alias Pelable.Chat.Message

  def seen_last_message?(user, chatroom) do
    Chat.seen_last_message?(user, chatroom)
  end

  def render_message(%Message{} = message) do
    {:safe, datetime} = content_tag(:datetime, message.inserted_at)
    {:safe, username} = content_tag(:b, " #{message.sender.username}" <> ": ")
    {:safe, body} = html_escape(message.body)
    {:safe, [60, "p", [], 62, datetime, username, body, 60, 47, "p", 62]}
    
  end
end
