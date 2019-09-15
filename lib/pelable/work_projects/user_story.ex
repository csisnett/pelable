defmodule Pelable.WorkProjects.UserStory do
  use Ecto.Schema
  import Ecto.Changeset

  alias Pelable.WorkProjects.{ProjectVersion, UserStory, WorkProject}

  schema "user_stories" do
    field :title, :string
    field :status, :string, default: "not started"
    field :required?, :boolean, default: true

    belongs_to :work_project, WorkProject
    timestamps()
  end

  def copy(%UserStory{} = user_story) do
    %{}
    |> Map.put("status", user_story.status) 
    |> Map.put("required?", user_story.required?)
    |> Map.put("title", user_story.title)
  end

  # %UserStory{} -> %{"title", "work_status", "required?"}
  #Gets together all the information from the %WorkProjectUserStory{} and its parent %UserStory{} into a map
  def get_user_story_info(%UserStory{} = user_story) do
    %{} 
    |> Map.put(:title, user_story.title) 
    |> Map.put(:status, user_story.status) 
    |> Map.put(:required?, user_story.required?)
  end

  def get_user_stories_info(user_stories) when is_list(user_stories) do
    Enum.map(user_stories, &WorkProjects.get_user_story_info/1)
  end


  @doc false
  def changeset(user_story, attrs) do
    user_story
    |> cast(attrs, [:title, :status, :required?, :work_project_id])
    |> validate_required([:title, :status, :required?, :work_project_id])
  end
end
