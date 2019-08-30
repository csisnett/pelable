defmodule Pelable.WorkProjects.ProjectVersion do
  use Ecto.Schema
  import Ecto.Changeset

  alias Pelable.Users.User
  alias Pelable.WorkProjects.{ProjectVersion, WorkProject}

  schema "project_versions" do
    field :first?, :boolean, default: true
    
    has_many :work_projects, WorkProject
    belongs_to :added_by, User
    belongs_to :parent, ProjectVersion
    timestamps()
  end

  @doc false
  def changeset(project_version, attrs) do
    project_version
    |> cast(attrs, [:first?, :parent_id])
    |> validate_required([:creator_id])
    |> foreign_key_constraint(:creator_id)
  end
end
