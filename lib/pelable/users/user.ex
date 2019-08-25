defmodule Pelable.Users.User do
  use Ecto.Schema
  use Pow.Ecto.Schema

  alias Pelable.WorkProject.{ProjectVersion, WorkProject}
  alias Pelable.Users.User

  schema "users" do
    field :username, :string
    field :nickname, :string
    field :fullname, :string
    
    many_to_many :work_projects, WorkProject, join_through: "work_project_user"
    many_to_many :project_bookmarks, ProjectVersion, join_through: "project_version_bookmark"
    pow_user_fields()
    timestamps()
  end
end
