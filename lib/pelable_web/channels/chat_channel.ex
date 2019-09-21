defmodule PelableWeb.ChatChannel do
  use PelableWeb, :channel

  alias Pelable.Chat
  alias PelableWeb.Presence
  alias Pelable.Repo
  alias Pelable.Users.User

  def join("chat:" <> uuid, payload, socket) do
    if authorized?(payload) do
      send(self(), :entered_chat)
      {:ok, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  def join("presence", payload, socket) do
    if authorized?(payload) do
      send(self(), :after_join)
      {:ok, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end


  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (chat:lobby).
  def handle_in("shout", payload, socket) do
    "chat:" <> uuid = socket.topic
    payload = Map.merge(payload, %{"chatroom_uuid" => uuid, "username" => socket.assigns.current_user.username})
    case Chat.create_message(payload) do
      {:ok, message} ->
        payload = Map.merge(payload, %{"inserted_at" => message.inserted_at})
      broadcast socket, "shout", payload
      {:noreply, socket}
      {:error, _message} ->
        {:noreply, socket}
    end
  end

  def handle_info(:entered_chat, socket) do

    user = Repo.get(User, socket.assigns[:current_user].id)
    {:ok, _} = Presence.track(socket, user.id, %{
      username: user.username,
      typing: false
    })
    push socket, "presence_state", Presence.list(socket)
    {:noreply, socket}
  end

  def handle_in("user:typing", %{"typing" => typing}, socket) do
    user = Repo.get(User, socket.assigns[:current_user].id)
    
    {:ok, _} = Presence.update(socket, user.id, %{
      username: user.username,
      typing: typing
    })
    push socket, "presence_state", Presence.list(socket)
    {:noreply, socket}
  end

  def handle_info(:after_join, socket) do
    
    user = Repo.get(User, socket.assigns[:current_user].id)
    {:ok, _} = Presence.track(socket, user.id, %{
      username: user.username,
      typing: false
    })
    push socket, "presence_state", Presence.list(socket)
    {:noreply, socket}
  end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end
