defmodule Pelable.Users.User do
  use Ecto.Schema
  use Pow.Ecto.Schema
  use Pow.Extension.Ecto.Schema, extensions: [PowResetPassword, PowEmailConfirmation]
  import Ecto.Changeset

  alias Pelable.Repo
  alias Pelable.WorkProjects.{ProjectVersion, WorkProject}
  alias Pelable.Users.User
  alias Pelable.Learn.Goal
  alias Pelable.Chat.{LastConnection, Chatroom, Message}

  schema "users" do
    field :username, :string
    field :nickname, :string
    field :fullname, :string
    
    many_to_many :goals, Goal, join_through: "user_goal"
    many_to_many :work_projects, WorkProject, join_through: "work_project_user"
    many_to_many :project_bookmarks, WorkProject, join_through: "project_bookmark"
    many_to_many :joined_chats, Chatroom, join_through: "chatroom_participant"
    many_to_many :chat_invitations, Chatroom, join_through: "chatroom_invitation"
    many_to_many :chat_connections, Chatroom, join_through: "last_connection"
    many_to_many :mentions, Message, join_through: "message_mention"
    has_many :last_connections, LastConnection
    pow_user_fields()
    timestamps()
  end

  def lowercase_username(changeset) do
    case get_field(changeset, :username) do
      nil -> changeset
      username ->
        if username == String.downcase(username) do
          changeset
        else
          changeset |> put_change(:username, String.downcase(username))
      end
      
    end
  end

  def replace_white_space(changeset) do
    case get_field(changeset, :username) do
      nil -> changeset
      username ->
        changeset |> put_change(:username, String.replace(username, ~r/ +/, ""))
    end
  end



  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :nickname, :fullname, :email])
    |> validate_required([:username, :email])
    |> lowercase_username
    |> replace_white_space
    |> pow_changeset(attrs)
    |> pow_extension_changeset(attrs)
    |> unique_constraint(:username)
    |> unique_constraint(:email)
  end
end
