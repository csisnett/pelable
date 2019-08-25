defmodule Pelable.WorkProject.UserStory do
  use Ecto.Schema
  import Ecto.Changeset

  schema "user_stories" do
    field :body, :string

    timestamps()
  end

  @doc false
  def changeset(user_story, attrs) do
    user_story
    |> cast(attrs, [:body])
    |> validate_required([:body])
  end
end
