defmodule PelableWeb.ChatroomView do
  alias Pelable.Chat
  use PelableWeb, :view

  def seen_last_message?(user, chatroom) do
    Chat.seen_last_message?(user, chatroom)
  end
end
