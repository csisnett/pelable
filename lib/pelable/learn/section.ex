defmodule Pelable.Learn.Section do
  use Ecto.Schema
  import Ecto.Changeset

  alias Pelable.Learn.{NameSlug, Workspace}

  schema "sections" do
    field :name, :string
    field :slug, NameSlug.Type
    field :uuid, Ecto.ShortUUID, autogenerate: true

    belongs_to :workspace, Workspace

    timestamps()
  end

  @doc false
  def changeset(section, attrs) do
    section
    |> cast(attrs, [:name, :uuid, :workspace_id])
    |> validate_required([:name, :uuid, :workspace_id])
    |> unique_constraint(:uuid)
    |> NameSlug.maybe_generate_slug
    |> unique_constraint(:name_must_be_unique, name: :unique_slug_name_index)
  end
end
