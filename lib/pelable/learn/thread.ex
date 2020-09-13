defmodule Pelable.Learn.Thread do
  use Ecto.Schema
  import Ecto.Changeset

  alias Pelable.Learn.{Section, Post}
  alias Pelable.Users.User

  schema "threads" do
    field :title, :string
    field :type, :string, default: "public"
    field :uuid, Ecto.ShortUUID, autogenerate: true
    
    belongs_to :creator, User
    timestamps()
  end

  @doc false
  def changeset(thread, attrs) do
    thread
    |> cast(attrs, [:title, :type, :creator_id])
    |> validate_required([:title, :type, :creator_id])
    |> unique_constraint(:uuid)
    |> foreign_key_constraint(:creator_id)
  end
end
