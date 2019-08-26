defmodule Pelable.Projects.Project do
  use Ecto.Schema
  import Ecto.Changeset
  alias Pelable.Users.User
  alias Pelable.WorkProjects.ProjectVersion
  
  schema "projects" do
    belongs_to :creator, User
    has_many :project_versions, ProjectVersion
    timestamps()
  end

  @doc false
  def changeset(project, attrs) do
    project
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
