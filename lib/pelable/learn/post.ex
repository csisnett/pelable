defmodule Pelable.Learn.Post do
  use Ecto.Schema
  import Ecto.Changeset

  alias Pelable.Learn.{Post, TitleSlug}
  alias Pelable.Users.User

  schema "posts" do
    field :title, :string
    field :body, :string
    field :uuid, Ecto.ShortUUID, autogenerate: true
    field :slug, TitleSlug.Type
    belongs_to :creator, User
    belongs_to :parent, Post
    timestamps()
  end

  def set_default_slug(changeset) do
    case get_field(changeset, :slug) do
      nil -> changeset |> put_change(:slug, "untitled")
      _ -> changeset
    end
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:title, :body, :parent_id, :creator_id])
    |> validate_required([:creator_id])
    |> unique_constraint(:uuid)
    |> foreign_key_constraint(:creator_id)
    |> foreign_key_constraint(:parent_id)
    |> TitleSlug.maybe_generate_slug
    |> set_default_slug
  end
end
