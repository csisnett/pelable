defmodule Pelable.Users.User do
  use Ecto.Schema
  use Pow.Ecto.Schema

  alias Pelable.WorkProject.ProjectVersion
  alias Pelable.Users.User

  schema "users" do
    field :username, :string
    field :nickname, :string
    field :fullname, :string
    
    many_to_many :project_versions, ProjectVersion, join_through: "project_version_user"
    pow_user_fields()
    timestamps()
  end
end
