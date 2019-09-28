defmodule PelableWeb.PresenceChannel do
    use PelableWeb, :channel
    alias PelableWeb.ChatTracker
    alias Pelable.Chat
    alias PelableWeb.Presence
    alias Pelable.Repo
    alias Pelable.Users.User
    alias PelableWeb.Endpoint


    def join("chat_presence", payload, socket) do
        if authorized?(payload) do
          send(self(), :after_join)
          {:ok, socket}
        else
          {:error, %{reason: "unauthorized"}}
        end
    end

    def handle_info(:after_join, socket) do
        user = socket.assigns[:current_user]
        {:ok, _} = Presence.track(socket, user.id, %{
          username: user.username
        })
        push socket, "presence_state", Presence.list(socket)
        {:noreply, socket}
      end

      defp authorized?(_payload) do
        true
      end

end