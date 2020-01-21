defmodule Pelable.Learn.Project do
  use Ecto.Schema
  import Ecto.Changeset

  alias Pelable.Users.User
  alias Pelable.Learn.{NameSlug}
  alias Pelable.Learn.Workspace

  schema "projects" do
    field :name, :string
    field :description, :string
    field :slug, NameSlug.Type
    field :uuid, Ecto.ShortUUID, autogenerate: true


    belongs_to :creator, User
    belongs_to :workspace, Workspace

    timestamps()
  end

  @doc false
  def changeset(project, attrs) do
    project
    |> cast(attrs, [:name, :description, :workspace_id, :creator_id])
    |> validate_required([:name, :workspace_id, :creator_id])
    |> unique_constraint(:uuid)
    |> NameSlug.maybe_generate_slug
  end
end
