defmodule PelableWeb.ChatChannel do
  use PelableWeb, :channel
  alias PelableWeb.ChatTracker
  alias Pelable.Chat
  alias PelableWeb.Presence
  alias Pelable.Repo
  alias Pelable.Users.User
  alias PelableWeb.Endpoint

  def convert_ids(ids) when is_list(ids) do
    ids |> Enum.map(fn id -> Integer.to_string(id) end)
  end

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
        Endpoint.broadcast("chat_notification:" <> uuid, "new_message", %{"new_message" => true})
        payload = Map.merge(payload, %{"inserted_at" => message.inserted_at})
        sanitized_body = Phoenix.HTML.html_escape(payload["body"]) |> Phoenix.HTML.safe_to_string
        payload = Map.put(payload, "body", sanitized_body)
      broadcast socket, "shout", payload
      push_notification(message, payload)
      {:noreply, socket}
      {:error, _message} ->
        {:noreply, socket}
    end
  end

  def push_notification(message, payload) do
    chatroom = Chat.get_chatroom!(message.chatroom_id)
    case chatroom.type do
    "private" <> something ->
    recipients = Chat.get_recipients(message) |> convert_ids
    json = %{"app_id" => "277bc59b-8037-4702-8a45-66cb485da805", "include_external_user_ids" => recipients, "data" => %{"foo" => "bar"}, "contents" => %{"en" => payload["username"] <> ": " <> payload["body"]}}
    encoded_json = Jason.encode!(json)
    HTTPoison.post("https://onesignal.com/api/v1/notifications", encoded_json, [{"Content-Type", "application/json"}, {"charset", "utf-8"}])
    
    anything_else -> :nothing
    end
  end

  def handle_info(:entered_chat, socket) do
    "chat:" <> uuid = socket.topic
    chatroom = Chat.get_chatroom_by_uuid(uuid)
    user = socket.assigns[:current_user]
    state = %{"user" => user, "chatroom" => chatroom, "pid" => self()}
    ChatTracker.start(state)
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

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end
