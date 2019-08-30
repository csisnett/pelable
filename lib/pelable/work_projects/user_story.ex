defmodule Pelable.WorkProjects.UserStory do
  use Ecto.Schema
  import Ecto.Changeset

  alias Pelable.WorkProjects.{ProjectVersion, UserStory, WorkProject}

  schema "user_stories" do
    field :title, :string
    many_to_many :work_projects, WorkProject, join_through: "work_project_user_story"
    timestamps()
  end

  @doc false
  def changeset(user_story, attrs) do
    user_story
    |> cast(attrs, [:title])
    |> validate_required([:title])
    |> unique_constraint(:title)
  end
end
