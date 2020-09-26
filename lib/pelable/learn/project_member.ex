defmodule Pelable.Learn.ProjectMember do
  use Ecto.Schema
  import Ecto.Changeset
  alias Pelable.Learn.{Project}

  schema "project_member" do
    field :withdrawal, :naive_datetime

    belongs_to :user, User
    belongs_to :project, Project
    timestamps()
  end

  @doc false
  def changeset(project_member, attrs) do
    project_member
    |> cast(attrs, [:withdrawal, :user_id, :project_id])
    |> validate_required([:user_id, :project_id])
    |> foreign_key_constraint(:user_id)
    |> foreign_key_constraint(:project_id)
  end
end
