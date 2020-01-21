defmodule Pelable.Learn.Project do
  use Ecto.Schema
  import Ecto.Changeset

  alias Pelable.Learn.Workspace

  schema "projects" do
    field :description, :string
    field :name, :string
    field :uuid, Ecto.ShortUUID, autogenerate: true

    belongs_to :workspace, Workspace

    timestamps()
  end

  @doc false
  def changeset(project, attrs) do
    project
    |> cast(attrs, [:name, :description, :workspace_id])
    |> validate_required([:name, :workspace_id])
    |> unique_constraint(:uuid)
  end
end
