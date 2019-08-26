defmodule Pelable.WorkProjects.ProjectVersion do
  use Ecto.Schema
  import Ecto.Changeset

  alias Pelable.Users.User
  alias Pelable.WorkProjects.{ProjectVersion, UserStory}
  alias Pelable.Projects.Project

  schema "project_versions" do
    field :name, :string
    field :description, :string
    field :public_status, :string, default: "public"
    field :first?, :boolean

    belongs_to :creator, User
    belongs_to :project_version, ProjectVersion
    belongs_to :project, Project
    many_to_many :bookmarked_by, User, join_through: "project_version_bookmark"
    many_to_many :user_stories, UserStory, join_through: "project_version_user_story"
    timestamps()
  end

  @doc false
  def changeset(project_version, attrs) do
    project_version
    |> cast(attrs, [:description, :name, :public_status, :first?])
    |> validate_required([:description, :name, :public_status, :first?])
  end
end
