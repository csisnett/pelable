defmodule PelableWeb.ChatChannel do
  use PelableWeb, :channel

  alias Pelable.Chat

  def join("chat:" <> uuid, payload, socket) do
    if authorized?(payload) do
      {:ok, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end


  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (chat:lobby).
  def handle_in("shout", payload, socket) do
    "chat:" <> uuid = socket.topic
    payload = Map.merge(payload, %{"chatroom_uuid" => uuid})
    Chat.create_message(payload)
    broadcast socket, "shout", payload
    {:noreply, socket}
  end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end
