defmodule Pelable.Learn.Post do
  use Ecto.Schema
  import Ecto.Changeset

  alias Pelable.Learn.Post

  schema "posts" do
    field :body, :string
    field :body_html, :string
    field :uuid, Ecto.ShortUUID, autogenerate: true

    belongs_to :parent, Post
    timestamps()
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:body, :body_html, :parent_id])
    |> validate_required([:body, :body_html])
    |> unique_constraint(:uuid)
    |> foreign_key_constraint(:parent_id)
  end
end
