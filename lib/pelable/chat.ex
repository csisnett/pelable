defmodule Pelable.Chat do
  @moduledoc """
  The Chat context.
  """

  import Ecto.Query, warn: false
  alias Pelable.Repo

  alias Pelable.Chat.{Chatroom, Message, LastConnection}
  alias Pelable.Learn
  alias Pelable.Users.User

  @chatroom_types ["public", "private conversation", "private group"]

  @doc """
  Returns the list of chatrooms.

  ## Examples

      iex> list_chatrooms()
      [%Chatroom{}, ...]

  """
  def list_chatrooms do
    Repo.all(Chatroom)
  end

  def list_public_chatrooms do
    query = from c in Chatroom,
            where: c.type == "public",
            select: c

    Repo.all(query)
  end

  def invite_to_chatroom(user, uuid) do
    chatroom = get_chatroom_by_uuid(uuid) |> Repo.preload([:creator, :participants, :invited_users])
    case chatroom.type do
      "private conversation" ->
        if participants(chatroom) >= 2 or invitations(chatroom) >= 1 do
          {:error, "No more than two people can join a private conversation"}
        else
          save_invitation(user, chatroom)
        end
        _any_other_type -> save_invitation(user, chatroom)
      end
  end

  # preloaded %Chatroom{} -> boolean
  def participants(chatroom) do
    Enum.count(chatroom.participants)
  end

  # preloaded %Chatroom{} -> boolean
  def invitations(chatroom) do
    Enum.count(chatroom.invited_users)
  end

  #Gets a user and a preloaded chatroom, adds user to :invited_users
  def save_invitation(user, chatroom) do
    chatroom_changeset = Ecto.Changeset.change(chatroom)
    chatroom_users_changeset = chatroom_changeset |> Ecto.Changeset.put_assoc(:invited_users, [user])
    Repo.update!(chatroom_users_changeset)
  end
  

  def seen_last_message?(%User{} = user, %Chatroom{} =  chatroom) do
    last_connection = get_last_connection(user, chatroom)
    query = from m in Message, where: m.inserted_at > ^last_connection.updated_at, select: m.id
    messages = Repo.all(query)
    length(messages) == 0
  end

  def get_last_connection(%User{} = user, %Chatroom{} = chatroom) do
    query = from lc in LastConnection, where: lc.user_id == ^user.id and lc.chatroom_id == ^chatroom.id, select: lc
    Repo.one(query)
  end

  def update_last_connection(%User{} = user, %Chatroom{} = chatroom) do
    case get_last_connection(user, chatroom) do
      nil -> create_last_connection(user, chatroom)
      last_connection ->
        now = DateTime.utc_now
        LastConnection.changeset(last_connection, %{"updated_at" => now}) |> Repo.update
    end
  end

  def create_last_connection(%User{} = user, %Chatroom{} =  chatroom) do
    attrs = %{} |> Map.put("user_id", user.id) |> Map.put("chatroom_id", chatroom.id)
    LastConnection.changeset(%LastConnection{}, attrs)
    |> Repo.insert
  end

  def join_chatroom(%User{} = user, uuid) do
    chatroom = get_chatroom_by_uuid(uuid) |> Repo.preload([:invited_users])
    case chatroom.type do
      "public" -> join_user_to_chatroom(user, chatroom)
      _any_other_type ->
        if invited?(user, chatroom) do
          join_user_to_chatroom(user, chatroom)
        else
        {:error, "You can't join, you haven't been invited to this chat"}
        end
    end
  end

  #%User{}, %Chatroom{} -> boolean 
  # Gets a User, and a preloaded chatroom returns true if user has been invited
  def invited?(user, chatroom) do
    case Enum.find(chatroom.invited_users, false, fn u -> u.id == user.id end) do
      %User{} -> true
      false -> false
    end
  end

  defp join_user_to_chatroom(%User{} = user, %Chatroom{} = chatroom) do
    chatroom = Repo.preload(chatroom, [:creator, :participants, :invited_users])
    chatroom_changeset = Ecto.Changeset.change(chatroom)
    chatroom_users_changeset = chatroom_changeset |> Ecto.Changeset.put_assoc(:participants, [user])
    Repo.update!(chatroom_users_changeset)
  end

  @doc """
  Gets a single chatroom.

  Raises `Ecto.NoResultsError` if the Chatroom does not exist.

  ## Examples

      iex> get_chatroom!(123)
      %Chatroom{}

      iex> get_chatroom!(456)
      ** (Ecto.NoResultsError)

  """
  def get_chatroom!(id), do: Repo.get!(Chatroom, id)

  def get_chatroom_by_uuid(uuid) do
    Repo.get_by(Chatroom, uuid: uuid)
  end

  @doc """
  Creates a chatroom.

  ## Examples

      iex> create_chatroom(%{field: value})
      {:ok, %Chatroom{}}

      iex> create_chatroom(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_chatroom(attrs \\ %{}) do
    %Chatroom{}
    |> Chatroom.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a chatroom.

  ## Examples

      iex> update_chatroom(chatroom, %{field: new_value})
      {:ok, %Chatroom{}}

      iex> update_chatroom(chatroom, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_chatroom(%Chatroom{} = chatroom, attrs) do
    chatroom
    |> Chatroom.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Chatroom.

  ## Examples

      iex> delete_chatroom(chatroom)
      {:ok, %Chatroom{}}

      iex> delete_chatroom(chatroom)
      {:error, %Ecto.Changeset{}}

  """
  def delete_chatroom(%Chatroom{} = chatroom) do
    Repo.delete(chatroom)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking chatroom changes.

  ## Examples

      iex> change_chatroom(chatroom)
      %Ecto.Changeset{source: %Chatroom{}}

  """
  def change_chatroom(%Chatroom{} = chatroom) do
    Chatroom.changeset(chatroom, %{})
  end

  

  @doc """
  Returns the list of messages.

  ## Examples

      iex> list_messages()
      [%Message{}, ...]

  """
  def list_messages do
    Repo.all(Message)
  end

  # Number -> [%{}]
  #Gets chatroom id, returns a list of messages with its users
  def list_messages_by_chatroom(id) do
    query = from m in Message,
    join: u in assoc(m, :sender),
    where: m.chatroom_id == ^id,
    order_by: [asc: m.inserted_at],
    preload: [sender: u]
    Repo.all(query)
  end

  @doc """
  Gets a single message.

  Raises `Ecto.NoResultsError` if the Message does not exist.

  ## Examples

      iex> get_message!(123)
      %Message{}

      iex> get_message!(456)
      ** (Ecto.NoResultsError)

  """
  def get_message!(id), do: Repo.get!(Message, id)

  @doc """
  Creates a message.

  ## Examples

      iex> create_message(%{field: value})
      {:ok, %Message{}}

      iex> create_message(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  
  def create_message(%{"chatroom_uuid" => uuid, "username" => username} = attrs) do
    chatroom = get_chatroom_by_uuid(uuid)
    user = Learn.get_user_by_username(username)
    attrs = Map.put(attrs, "chatroom_id", chatroom.id) |> Map.put("sender_id", user.id)
    %Message{}
    |> Message.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a message.

  ## Examples

      iex> update_message(message, %{field: new_value})
      {:ok, %Message{}}

      iex> update_message(message, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_message(%Message{} = message, attrs) do
    message
    |> Message.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Message.

  ## Examples

      iex> delete_message(message)
      {:ok, %Message{}}

      iex> delete_message(message)
      {:error, %Ecto.Changeset{}}

  """
  def delete_message(%Message{} = message) do
    Repo.delete(message)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking message changes.

  ## Examples

      iex> change_message(message)
      %Ecto.Changeset{source: %Message{}}

  """
  def change_message(%Message{} = message) do
    Message.changeset(message, %{})
  end
end
