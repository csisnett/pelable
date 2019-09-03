defmodule Pelable.WorkProjects.WorkProjectUserStory do
  use Ecto.Schema
  import Ecto.Changeset

  schema "work_project_user_story" do
    field :status, :string, default: "not started"
    field :required?, :boolean, default: true
    field :work_project_id, :id
    field :user_story_id, :id

    timestamps()
  end

  @doc false
  def changeset(work_project_user_story, attrs) do
    work_project_user_story
    |> cast(attrs, [:status, :work_project_id, :user_story_id, :required?])
    |> validate_required([:status, :work_project_id, :user_story_id, :required?])
  end
end
