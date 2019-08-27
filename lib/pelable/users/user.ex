defmodule Pelable.Users.User do
  use Ecto.Schema
  use Pow.Ecto.Schema
  import Ecto.Changeset

  alias Pelable.Repo
  alias Pelable.WorkProjects.{ProjectVersion, WorkProject}
  alias Pelable.Users.User
  alias Pelable.Learn.Goal

  schema "users" do
    field :username, :string
    field :nickname, :string
    field :fullname, :string
    
    many_to_many :goals, Goal, join_through: "user_goal"
    many_to_many :work_projects, WorkProject, join_through: "work_project_user"
    many_to_many :project_bookmarks, ProjectVersion, join_through: "project_version_bookmark"
    pow_user_fields()
    timestamps()
  end

  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :nickname, :fullname, :email])
    |> validate_required([:username, :email, :nickname])
    |> unique_constraint(:username)
    |> unique_constraint(:email)
  end
end
