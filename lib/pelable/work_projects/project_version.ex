defmodule Pelable.WorkProjects.ProjectVersion do
  use Ecto.Schema
  import Ecto.Changeset

  alias Pelable.Users.User
  alias Pelable.WorkProjects.{ProjectVersion, WorkProject}
  alias Pelable.Learn.Tag

  schema "project_versions" do
    field :first?, :boolean, default: true
    
    many_to_many :tags, Tag, join_through: "project_version_tag"
    has_many :work_projects, WorkProject
    belongs_to :parent, ProjectVersion
    timestamps()
  end

  @doc false
  def changeset(project_version, attrs) do
    project_version
    |> cast(attrs, [:first?, :parent_id])
    |> validate_required([:first?])
  end
end
