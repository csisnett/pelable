defmodule Pelable.WorkProject.UserStory do
  use Ecto.Schema
  import Ecto.Changeset

  alias Pelable.WorkProject.{ProjectVersion, UserStory}

  schema "user_stories" do
    field :body, :string

    many_to_many :project_version, ProjectVersion, join_through: "project_version_user_story"
    timestamps()
  end

  @doc false
  def changeset(user_story, attrs) do
    user_story
    |> cast(attrs, [:body])
    |> validate_required([:body])
  end
end
