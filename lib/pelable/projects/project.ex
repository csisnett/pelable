defmodule Pelable.Projects.Project do
  use Ecto.Schema
  import Ecto.Changeset
  alias Pelable.Users.User

  schema "projects" do
    belongs_to :creator, User
    timestamps()
  end

  @doc false
  def changeset(project, attrs) do
    project
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
