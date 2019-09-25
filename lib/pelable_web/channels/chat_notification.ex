defmodule PelableWeb.ChatNotificationChannel do
    use PelableWeb, :channel

    alias PelableWeb.ChatTracker
    alias Pelable.Chat
    alias PelableWeb.Presence
    alias Pelable.Repo
    alias Pelable.Users.User
    

    def join("chat_notification:" <> uuid, payload, socket) do
        if authorized?(payload) do
          send(self(), :entered_notification)
          {:ok, socket}
        else
          {:error, %{reason: "unauthorized"}}
        end
      end

    def handle_info(:entered_notification, socket) do
        push socket, "new_notification", %{"subscribed" => socket.topic}
        {:noreply, socket}
    end

    def handle_in(:new_message, socket) do
        "chat:" <> uuid = socket.topic
        new_topic = "chat_notification:" <> uuid
        push socket, "new_notification", %{"new_message" => true}
        {:noreply, socket}
    end

    defp authorized?(_payload) do
        true
    end

end