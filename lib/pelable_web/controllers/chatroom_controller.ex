defmodule PelableWeb.ChatroomController do
  use PelableWeb, :controller

  alias Pelable.Chat
  alias Pelable.Chat.Chatroom
  alias Pelable.Repo
  alias PelableWeb.PowMailer
  alias Pelable.Batches

  def index(conn, _params) do
    chatrooms = Chat.list_chatrooms()
    render(conn, "index.html", chatrooms: chatrooms)
  end

  def new(conn, _params) do
    changeset = Chat.change_chatroom(%Chatroom{})
    render(conn, "new.html", changeset: changeset)
  end

  def new_participant(conn, %{"uuid" => uuid} = params) do
    chatroom = Repo.get_by(Chatroom, uuid: uuid)
    Batches.add_user_to_team(conn.assigns.current_user, chatroom)
    event = conn.assigns.current_user.username <> " aka " <> conn.assigns.current_user.email <> " has accepted the invitation from " <> chatroom.name
    PowMailer.send_admin(%{"text" => event, "html" => event, "subject" => chatroom.name <> " invitation accepted by " <> conn.assigns.current_user.username})
    conn = conn |> put_flash(:info, "You have accepted the invitation successfully")
    show(conn, params)
  end

  def new_team(conn, %{"uuid" => uuid} = params) do
    chatroom = Repo.get_by(Chatroom, uuid: uuid)
    Batches.new_team_request(conn.assigns.current_user, chatroom)
    conn = conn |> put_flash(:info, "Your request has been sent successfully. We'll send you an invitation to join a new team")
    show(conn, %{"uuid" => "c3EMBSqNzdRo"})
  end

  def decline(conn, %{"uuid" => uuid} = params) do
    conn = conn |> put_flash(:info, "You have declined the invitation.")
    chatroom = Repo.get_by(Chatroom, uuid: uuid)
    event = conn.assigns.current_user.username <> " aka " <> conn.assigns.current_user.email <> " has declined the invitation from " <> chatroom.name
    PowMailer.send_admin(%{"text" => event, "html" => event, "subject" => chatroom.name <> " invitation declined by " <> conn.assigns.current_user.username})
    show(conn, %{"uuid" => "c3EMBSqNzdRo"})
  end

  def create(conn, %{"chatroom" => chatroom_params}) do
    case Chat.create_chatroom(chatroom_params) do
      {:ok, chatroom} ->
        conn
        |> put_flash(:info, "Chatroom created successfully.")
        |> redirect(to: Routes.chatroom_path(conn, :show, chatroom))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"uuid" => uuid}) do
    case conn.assigns.current_user do
      nil -> redirect(conn, to: Routes.pow_registration_path(conn, :new))
      current_user ->
    chatroom = Chat.get_chatroom_by_uuid(uuid) |> Repo.preload([:participants])
    messages = Chat.list_messages_by_chatroom(chatroom.id)
    current_user = current_user |> Repo.preload([:joined_chats, :chat_invitations])
    public_chatrooms = Chat.list_public_chatrooms
    private_groups = Chat.filter_private_groups(current_user.joined_chats)
    private_conversations = Chat.filter_private_conversations(current_user.joined_chats) |> Enum.map( fn c ->  Repo.preload(c, [:participants]) end)
    chat(conn, chatroom, messages, current_user, public_chatrooms, private_groups, private_conversations)
    end
  end

  def chat(conn, chatroom, messages, current_user, public_chatrooms, private_groups, private_conversations) do
    render(conn, "show.html", chatroom: chatroom, messages:
     messages, user: current_user, public_chatrooms: public_chatrooms,
      private_groups: private_groups, private_conversations: private_conversations)
  end



  def edit(conn, %{"id" => id}) do
    chatroom = Chat.get_chatroom!(id)
    changeset = Chat.change_chatroom(chatroom)
    render(conn, "edit.html", chatroom: chatroom, changeset: changeset)
  end

  def update(conn, %{"id" => id, "chatroom" => chatroom_params}) do
    chatroom = Chat.get_chatroom!(id)

    case Chat.update_chatroom(chatroom, chatroom_params) do
      {:ok, chatroom} ->
        conn
        |> put_flash(:info, "Chatroom updated successfully.")
        |> redirect(to: Routes.chatroom_path(conn, :show, chatroom))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", chatroom: chatroom, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    chatroom = Chat.get_chatroom!(id)
    {:ok, _chatroom} = Chat.delete_chatroom(chatroom)

    conn
    |> put_flash(:info, "Chatroom deleted successfully.")
    |> redirect(to: Routes.chatroom_path(conn, :index))
  end
end
