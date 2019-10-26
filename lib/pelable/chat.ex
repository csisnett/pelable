defmodule Pelable.Chat do
  @moduledoc """
  The Chat context.
  """

  import Ecto.Query, warn: false
  alias Pelable.Repo

  alias Pelable.Chat.{Chatroom, Message, LastConnection, Invitation, Participant, Mention}
  alias Pelable.Learn
  alias Pelable.Users.User
  alias Pelable.Chat
  alias PelableWeb.PowMailer

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
    query = from c in Chatroom, where: c.type == "public", select: c
    Repo.all(query)
  end

  # preloaded %Chatroom{} -> Integer
  def participants(%Chatroom{} = chatroom) do
    Enum.count(chatroom.participants)
  end

  def get_participant(%Chatroom{} = chatroom,%User{} = user) do
    query = from p in Participant, where: p.chatroom_id == ^chatroom.id and p.user_id == ^user.id, select: p
    Repo.one(query)
  end

  # preloaded %Chatroom{} -> Integer
  def invitations(%Chatroom{} = chatroom) do
    Enum.count(chatroom.invited_users)
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

    def add_participant(%User{} = user, %Chatroom{} = chatroom) do
      %Participant{}
      |> Participant.changeset(%{"user_id" => user.id, "chatroom_id" => chatroom.id})
      |> Repo.insert
    end

    def add_participant(username, chatroom_uuid) do
      user = Repo.get_by(User, username: username)
      chatroom = Repo.get_by(Chatroom, uuid: chatroom_uuid)
      add_participant(user, chatroom)
    end

    def join_user_to_chatroom(%User{} = user, %Chatroom{} = chatroom) do
      chatroom = Repo.preload(chatroom, [:creator, :participants, :invited_users])
      chatroom_changeset = Ecto.Changeset.change(chatroom)
      chatroom_users_changeset = chatroom_changeset |> Ecto.Changeset.put_assoc(:participants, [user])
      delete_invitation(user, chatroom)
      Repo.update!(chatroom_users_changeset)
    end
  

  def invite_to_chatroom(%User{} = user, uuid) do
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

   #Gets a user and a preloaded chatroom, adds user_id,chatroom_id to chatroom_invitation table
   def save_invitation(%User{} = user, %Chatroom{} =  chatroom) do
    chatroom_changeset = Ecto.Changeset.change(chatroom)
    chatroom_users_changeset = chatroom_changeset |> Ecto.Changeset.put_assoc(:invited_users, [user])
    Repo.update!(chatroom_users_changeset)
  end

  def delete_invitation(user = %User{}, chatroom = %Chatroom{}) do
    from(i in Invitation, where: i.user_id == ^user.id and i.chatroom_id == ^chatroom.id) |> Repo.delete_all
  end

  def delete_participant(%Chatroom{} = chatroom, %User{} = user) do
      get_participant(chatroom, user) |> Repo.delete
  end

  def delete_participant(uuid, username) do
    chatroom = Repo.get_by(Chatroom, uuid: uuid)
    user = Repo.get_by(User, username: username)
    delete_participant(chatroom, user)
  end

    #%User{}, %Chatroom{} -> boolean 
    # Gets a User, and a preloaded chatroom returns true if user has been invited
    def invited?(%User{} = user, %Chatroom{} = chatroom) do
      case Enum.find(chatroom.invited_users, false, fn u -> u.id == user.id end) do
        %User{} -> true
        false -> false
      end
    end


  def get_last_message(%Chatroom{} = chatroom) do
    Repo.one(from m in Message, where: m.chatroom_id == ^chatroom.id, order_by: [desc: m.id], limit: 1)
  end

  def get_last_message(uuid) do
    chatroom = Repo.get_by(Chatroom, uuid: uuid)
    get_last_message(chatroom)
  end


  def seen_last_message?(%User{} = user, %Chatroom{} =  chatroom) do
    last_connection = get_last_connection(user, chatroom)
    case last_connection do
      nil -> false
      last_connection ->

        last_message = get_last_message(chatroom)
    
        NaiveDateTime.compare(last_connection.updated_at, last_message.inserted_at) == :gt
      end
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

  def private_conversations(%User{} = user, "private conversations" = type) do
    get_conversations(user, type)
    |> Enum.map(fn c -> Repo.preload(c, [:participants]) end)
  end

  def filter_private_conversations(chatrooms) when is_list(chatrooms) do
    chatrooms |> Enum.filter(fn chatroom -> chatroom.type == "private conversation" end)
  end

  def filter_private_groups(chatrooms) do
    chatrooms |> Enum.filter(fn chatroom -> chatroom.type == "private group" end)
  end


  def get_conversations(%User{} = user, type) do
    user = Repo.preload(user, [:joined_chats])
    user.joined_chats
    |> Enum.filter(fn chatroom -> chatroom.type == type end)
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
  #Always use create_chatroom_assoc to create chatrooms to have at least one message in the chat(otherwise seen_last_message? doesn't work for new users)
  defp create_chatroom(attrs \\ %{}) do
    %Chatroom{}
    |> Chatroom.changeset(attrs)
    |> Repo.insert()
  end

  def create_chatroom_assoc(%{"name" => _name, "creator_id" => _id, "type" => _type} = attrs) do
    {:ok, chatroom} = create_chatroom(attrs)
    initial_message = %{"chatroom_uuid" => chatroom.uuid, "username" => "pelable_bot", "body" => "Hello there, this is the start of this chat!"}
    {:ok, message} = create_message(initial_message)
    chatroom
  end

  #Deletes all messages except the first one(which is needed so that seen_last_message? works)
  def clear_chatroom(%Chatroom{} = chatroom) do
    messages = list_messages_by_chatroom(chatroom.id)
    [first | to_be_deleted] = messages
    Enum.each(to_be_deleted, fn m -> delete_message(m) end)
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

  # %Message{} -> [1, 5, ..]
  def get_recipients(%Message{} = message) do
    query = from p in Participant,
    where: p.chatroom_id == ^message.chatroom_id and p.user_id != ^message.sender_id,
    select: p.user_id
    Repo.all(query)
  end

  def get_user_recipients(%Message{} = message) do
    query = from p in Participant, where: p.chatroom_id == ^message.chatroom_id and p.user_id != ^message.sender_id,
    join: u in User,
    on: p.user_id == u.id,
    select: u
    Repo.all(query)
  end

  def list_messages_after_datetime(id, %NaiveDateTime{} = datetime) do
    query = from m in Message,
    join: u in assoc(m, :sender),
    where: m.chatroom_id == ^id and m.inserted_at >= ^datetime,
    order_by: [asc: m.inserted_at],
    preload: [sender: u]
    Repo.all(query)
  end

  def list_messages_before_datetime(id, %NaiveDateTime{} = datetime) do
    query = from m in Message,
    join: u in assoc(m, :sender),
    where: m.chatroom_id == ^id and m.inserted_at < ^datetime,
    order_by: [asc: m.inserted_at],
    preload: [sender: u]
    Repo.all(query)
  end

  # Number -> [%{}]
  #Gets chatroom id, returns a list of messages with its users
  # Chatroom's show.html.eex and clear_chatroom depend on this
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

  def create_message_external(%{} = attrs) do
    case create_message(attrs) do
      {:ok, message} ->
      check_mentions(message)
      {:ok, message}
    end
  end

  def get_chatroom_type(%Message{} = message) do
    query = from c in Chatroom, where: c.id == ^message.chatroom_id, select: c.type
    Repo.one(query)
  end

  def get_username_from_mention(mention) when is_list(mention) do
    [first| rest] = mention
    [username | _] = rest
    username
  end

  def create_mention(%Message{} = message, %User{} = user) do
    attrs = %{"message_id" => message.id, "user_id" => user.id}
    %Mention{}
    |> Mention.changeset(attrs)
    |> Repo.insert
  end

  #List of mention tuples {:ok, Mention} || {:error, changeset} -> %Mention{}
  # Only returns the ok mentions
  def ok_mentions(mentions) when is_list(mentions) do
    case length(mentions) do
      0 -> []
      x ->
        [first_mention | rest] = mentions
        case first_mention do
          {:error, _c} -> ok_mentions(rest)
          {:ok, mention} -> [mention] ++ ok_mentions(rest)
        end
    end
  end

  defp insert_mentions(mentioned_users, %Message{} = message) when is_list(mentioned_users) do
    mentions = Enum.map(mentioned_users, fn user -> create_mention(message, user) end)
    okay_mentions = ok_mentions(mentions)
    case length(okay_mentions) do
      [] -> :no_mentions
      x ->
        okay_mentions
    end
  end

  #[["@pelable.com", "pelable.com"], ["@carlos", "carlos"], ...] -> [%User{}, %User{}, ..] || []
  # Gets a list of possible mentions and returns a list of mentioned users
  def filter_mentions(mention_list) when is_list(mention_list) do
    case length(mention_list) do
      0 -> []
      x ->
      [first_mention | rest] = mention_list
      case Repo.get_by(User, username: get_username_from_mention(first_mention)) do
        nil -> filter_mentions(rest)
        user -> [user] ++ filter_mentions(rest)
      end
    end
  end

  #If a user mentioned  in message.body exists creates %Mention{}
  def check_public_mentions(%Message{} = message) do
    possible_mentions = Regex.scan(~r/@([^\s]+)/, message.body)
    case filter_mentions(possible_mentions) do
      [] -> :no_mentions
      mentioned_users -> insert_mentions(mentioned_users, message)
    end
  end

  #If a recipient is mentioned in message.body creates a %Mention{}
  def check_private_mentions(%Message{} = message) do
    recipients = get_user_recipients(message)
    case Enum.filter(recipients, fn user -> String.contains?(message.body, "@" <> user.username) end) do
        [] -> :no_mentions
        mentioned_users -> insert_mentions(mentioned_users, message)
      end
  end

  def check_mentions(message) do
    case String.contains?(message.body, "@") do
      false -> :no_mentions
      true -> 
        case get_chatroom_type(message)do
          "public" <> whatever -> check_public_mentions(message)
          "private" <> anything -> check_private_mentions(message)
      end
    end
  end
  
  def create_message(%{"chatroom_uuid" => uuid, "username" => username} = attrs) do
    chatroom = get_chatroom_by_uuid(uuid)
    user = Learn.get_user_by_username(username)
    attrs = Map.put(attrs, "chatroom_id", chatroom.id) |> Map.put("sender_id", user.id)
    %Message{}
    |> Message.changeset(attrs)
    |> Repo.insert()
  end

  def create_message(%{"chatroom_id" => _id, "sender_id" => _user_id} = attrs) do
    %Message{}
    |> Message.changeset(attrs)
    |> Repo.insert
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

  def send_email_blast(%{user: user, subject: subject, text: text, html: html} = attrs) do
    attrs
    |> PowMailer.cast
    |> PowMailer.process
  end
end
