defmodule Pelable.Learn.Post do
  use Ecto.Schema
  import Ecto.Changeset

  schema "posts" do
    field :body, :string
    field :body_html, :string
    field :uuid, Ecto.ShortUUID

    timestamps()
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:body, :body_html])
    |> validate_required([:body, :body_html])
    |> unique_constraint(:uuid)
  end
end
