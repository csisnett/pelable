defmodule Pelable.Learn.Resource do
  use Ecto.Schema
  import Ecto.Changeset

  schema "resources" do
    field :url, :string

    timestamps()
  end

  @doc false
  def changeset(resource, attrs) do
    resource
    |> cast(attrs, [:url])
    |> validate_required([:url])
  end
end
