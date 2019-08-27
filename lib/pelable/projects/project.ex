defmodule Pelable.Projects.Project do
  use Ecto.Schema
  import Ecto.Changeset
  alias Pelable.Users.User
  alias Pelable.WorkProjects.ProjectVersion
  alias Pelable.Projects.Project

  schema "projects" do
    belongs_to :creator, User
    has_many :versions, ProjectVersion
    timestamps()
  end

  @doc false
  def changeset(project, attrs) do
    project
    |> cast(attrs, [:creator_id])
    |> validate_required([:creator_id])
    |> foreign_key_constraint(:creator_id)
  end
end
