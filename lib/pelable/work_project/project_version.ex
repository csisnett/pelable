defmodule Pelable.WorkProject.ProjectVersion do
  use Ecto.Schema
  import Ecto.Changeset

  alias Pelable.Users.User

  schema "project_versions" do
    field :description, :string
    field :name, :string
    field :public_status, :string
    field :creator_id, :id
    field :parent_id, :id
    field :project_id, :id

    many_to_many :users, User, join_through: "project_version_user"
    timestamps()
  end

  @doc false
  def changeset(project_version, attrs) do
    project_version
    |> cast(attrs, [:description, :name, :public_status])
    |> validate_required([:description, :name, :public_status])
  end
end
