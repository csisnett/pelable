defmodule Pelable.WorkProjects.UserStory do
  use Ecto.Schema
  import Ecto.Changeset

  alias Pelable.WorkProjects.{ProjectVersion, UserStory, WorkProject}

  schema "user_stories" do
    field :title, :string
    field :status, :string, virtual: true
    field :required?, :boolean, virtual: true

    many_to_many :work_projects, WorkProject, join_through: "work_project_user_story"
    timestamps()
  end

  @doc false
  def changeset(user_story, attrs) do
    user_story
    |> cast(attrs, [:title, :status, :required?])
    |> validate_required([:title, :status, :required?])
    |> unique_constraint(:title)
  end
end
