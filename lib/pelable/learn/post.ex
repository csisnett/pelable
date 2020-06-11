defmodule Pelable.Learn.Post do
  use Ecto.Schema
  import Ecto.Changeset

  alias Pelable.Learn.Post
  alias Pelable.Users.User

  schema "posts" do
    field :body, :string
    field :uuid, Ecto.ShortUUID, autogenerate: true

    belongs_to :creator, User
    belongs_to :parent, Post
    timestamps()
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:body, :parent_id, :creator_id])
    |> validate_required([:creator_id])
    |> unique_constraint(:uuid)
    |> foreign_key_constraint(:creator_id)
    |> foreign_key_constraint(:parent_id)
  end
end
