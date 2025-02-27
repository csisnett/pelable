defmodule PelableWeb.UserSocket do
  use Phoenix.Socket, log: :debug
  alias Pelable.Repo
  alias Pelable.Users.User

  channel "chat:*", PelableWeb.ChatChannel
  channel "chat_notification:*", PelableWeb.ChatNotificationChannel
  channel "chat_presence", PelableWeb.PresenceChannel
  
  ## Channels
  # channel "room:*", PelableWeb.RoomChannel

  # Socket params are passed from the client and can
  # be used to verify and authenticate a user. After
  # verification, you can put default assigns into
  # the socket that will be set for all channels, ie
  #
  #     {:ok, assign(socket, :user_id, verified_user_id)}
  #
  # To deny connection, return `:error`.
  #
  # See `Phoenix.Token` documentation for examples in
  # performing token verification on connect.
  def connect(%{"token" => token}, socket, _connect_info) do
    case Phoenix.Token.verify(socket, "BndIeIG1Y5aZGD534Z0WFpwG+oBWlOkeD/C1lIGvR+mSKF0rNpRWYodPr+0YM2yr", token, max_age: 86400) do
      {:ok, user_id} ->
        socket = assign(socket, :current_user, Repo.get!(User, user_id))
        {:ok, socket}
      {:error, _} ->
        :error
    end
  end

  # Socket id's are topics that allow you to identify all sockets for a given user:
  #
  #     def id(socket), do: "user_socket:#{socket.assigns.user_id}"
  #
  # Would allow you to broadcast a "disconnect" event and terminate
  # all active sockets and channels for a given user:
  #
  #     PelableWeb.Endpoint.broadcast("user_socket:#{user.id}", "disconnect", %{})
  #
  # Returning `nil` makes this socket anonymous.
  def id(_socket), do: nil
end
