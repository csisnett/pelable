defmodule Pelable.WorkProjects.ProjectUserStory do
  use Ecto.Schema
  import Ecto.Changeset

  alias Pelable.WorkProjects.{WorkProject, UserStory}

  schema "work_project_user_story" do
    field :status, :string

    belongs_to :work_project, WorkProject
    belongs_to :user_story, UserStory
    timestamps()
  end

  @doc false
  def changeset(project_user_story, attrs) do
    project_user_story
    |> cast(attrs, [:status])
    |> validate_required([:status])
    |> foreign_key_constraint(:work_project_id)
    |> foreign_key_constraint(:user_story_id)
    |> unique_constraint(:only_one_user_per_work_project, name: :unique_user_work_project)
  end
end
