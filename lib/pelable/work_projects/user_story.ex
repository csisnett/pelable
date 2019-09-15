defmodule Pelable.WorkProjects.UserStory do
  use Ecto.Schema
  import Ecto.Changeset

  alias Pelable.WorkProjects.{ProjectVersion, UserStory, WorkProject}

  schema "user_stories" do
    field :title, :string
    field :status, :string
    field :required?, :boolean

    belongs_to :work_project, WorkProject
    timestamps()
  end

  @doc false
  def changeset(user_story, attrs) do
    user_story
    |> cast(attrs, [:title, :status, :required?])
    |> validate_required([:title, :status, :required?])
  end
end
