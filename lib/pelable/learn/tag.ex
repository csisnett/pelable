defmodule Pelable.Learn.Tag do
  use Ecto.Schema
  import Ecto.Changeset

  alias Pelable.WorkProjects.ProjectVersion

  schema "tags" do
    field :name, :string
    many_to_many :project_versions, ProjectVersion, join_through: "project_version_tag"
    timestamps()
  end

  @doc false
  def changeset(tag, attrs) do
    tag
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
