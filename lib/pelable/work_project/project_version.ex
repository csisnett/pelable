defmodule Pelable.WorkProject.ProjectVersion do
  use Ecto.Schema
  import Ecto.Changeset

  alias Pelable.Users.User
  alias Pelable.WorkProject.{ProjectVersion, UserStory}
  alias Pelable.Projects.Project

  schema "project_versions" do
    field :name, :string
    field :description, :text
    field :public_status, :string, default: "public"

    belongs_to :creator, User
    belongs_to :project_versions, ProjectVersion
    belongs_to :project, Project
    many_to_many :user_stories, UserStory, join_through: "project_version_user_story"
    timestamps()
  end

  @doc false
  def changeset(project_version, attrs) do
    project_version
    |> cast(attrs, [:description, :name, :public_status])
    |> validate_required([:description, :name, :public_status])
  end
end
