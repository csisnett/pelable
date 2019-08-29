defmodule Pelable.WorkProjects.WorkProjectUserStory do
  use Ecto.Schema
  import Ecto.Changeset

  schema "work_project_user_story" do
    field :status, :string, default: "not started"
    field :work_project_id, :id
    field :user_story_id, :id

    timestamps()
  end

  @doc false
  def changeset(work_project_user_story, attrs) do
    work_project_user_story
    |> cast(attrs, [:status])
    |> validate_required([:status])
  end
end
