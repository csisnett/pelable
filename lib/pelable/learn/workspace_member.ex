defmodule Pelable.Learn.WorkspaceMember do
  use Ecto.Schema
  import Ecto.Changeset

  alias Pelable.Users.User
  alias Pelable.Learn.Workspace

  schema "workspace_member" do
    field :withdrawal, :naive_datetime
    field :personal?, :boolean

    belongs_to :user, User
    belongs_to :workspace, Workspace
    timestamps()
  end

  @doc false
  def changeset(workspace_member, attrs) do
    workspace_member
    |> cast(attrs, [:user_id, :workspace_id, :withdrawal, :personal?])
    |> validate_required([:user_id, :workspace_id, :personal?])
    |> foreign_key_constraint(:user_id)
    |> foreign_key_constraint(:workspace_id)
  end
end
