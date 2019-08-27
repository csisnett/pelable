defmodule Pelable.WorkProjects.UserStory do
  use Ecto.Schema
  import Ecto.Changeset

  alias Pelable.WorkProjects.{ProjectVersion, UserStory, WorkProject}

  schema "user_stories" do
    field :body, :string

    many_to_many :project_version, ProjectVersion, join_through: "project_version_user_story"
    many_to_many :work_projects, WorkProject, join_through: "work_project_user_story"
    timestamps()
  end

  @doc false
  def changeset(user_story, attrs) do
    user_story
    |> cast(attrs, [:body])
    |> validate_required([:body])
    |> unique_constraint(:body)
  end
end
