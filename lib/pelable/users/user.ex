defmodule Pelable.Users.User do
  use Ecto.Schema
  use Pow.Ecto.Schema
  use Pow.Extension.Ecto.Schema, extensions: [PowResetPassword, PowEmailConfirmation]
  import Ecto.Changeset

  alias Pelable.Repo
  alias Pelable.WorkProjects.{ProjectVersion, WorkProject}
  alias Pelable.Users.User
  alias Pelable.Learn.Goal
  alias Pelable.Chat.Chatroom

  schema "users" do
    field :username, :string
    field :nickname, :string
    field :fullname, :string
    
    many_to_many :goals, Goal, join_through: "user_goal"
    many_to_many :work_projects, WorkProject, join_through: "work_project_user"
    many_to_many :project_bookmarks, WorkProject, join_through: "project_bookmark"
    many_to_many :joined_chats, Chatroom, join_through: "chatroom_participant"
    many_to_many :chat_invitations, Chatroom, join_through: "chatroom_invitation"
    pow_user_fields()
    timestamps()
  end

  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :nickname, :fullname, :email])
    |> validate_required([:username, :email])
    |> pow_changeset(attrs)
    |> pow_extension_changeset(attrs)
    |> unique_constraint(:username)
    |> unique_constraint(:email)
  end
end
