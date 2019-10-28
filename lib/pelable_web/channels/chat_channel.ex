defmodule PelableWeb.ChatChannel do
  use PelableWeb, :channel
  alias PelableWeb.ChatTracker
  alias Pelable.Chat
  alias Chat.{Message}
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

  def prepare_payload(%Message{} = message, %{} = payload, socket) do
    payload = Map.put(payload, "username", socket.assigns.current_user.username)
    payload = Map.merge(payload, %{"inserted_at" => message.inserted_at})
    sanitized_body = Phoenix.HTML.html_escape(payload["body"]) |> Phoenix.HTML.safe_to_string
    payload = Map.put(payload, "body", sanitized_body)
  end

  def broadcast_notification(uuid) do
    Endpoint.broadcast("chat_notification:" <> uuid, "new_message", %{"new_message" => true})
  end

  def insert_mentions(%{} = payload, :no_mentions) do
    payload
  end

  def insert_mentions(%{} = payload, mentioned_users) do
    mentioned_usernames = Enum.map(mentioned_users, fn user -> user.username end)
    Map.put(payload, "mentioned_usernames", mentioned_usernames)
  end

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (chat:lobby).
  def handle_in("shout", payload, socket) do
    "chat:" <> uuid = socket.topic
    payload = Map.merge(payload, %{"chatroom_uuid" => uuid, "sender_id" => socket.assigns.current_user.id})
    case Chat.create_message_external(payload) do
      {:ok, message, users_mentioned} ->
        payload = prepare_payload(message, payload, socket) |> insert_mentions(users_mentioned)

        broadcast socket, "shout", payload

        broadcast_notification(uuid)
        send_push_notification(message, payload)
        {:noreply, socket}
        {:error, _message} ->
        {:noreply, socket}
    end
  end

  def send_push_notification(message, payload) do
    chatroom = Chat.get_chatroom!(message.chatroom_id)
    case chatroom.type do
    "private" <> something ->
    recipients = Chat.get_recipients(message) |> convert_ids
    json = %{"app_id" => "277bc59b-8037-4702-8a45-66cb485da805", "url" => "https://pelable.com/chat/" <> chatroom.uuid, "include_external_user_ids" => recipients, "data" => %{"foo" => "bar"}, "headings" => %{"en" => chatroom.name}, "contents" => %{"en" => payload["username"] <> ": " <> message.body}}
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
