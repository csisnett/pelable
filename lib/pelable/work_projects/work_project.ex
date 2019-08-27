defmodule Pelable.WorkProjects.WorkProject do
  use Ecto.Schema
  import Ecto.Changeset

  alias Pelable.Users.User
  alias Pelable.WorkProjects.{WorkProject, ProjectVersion}

  schema "work_projects" do
    field :description, :string
    field :end_date, :utc_datetime
    field :public_status, :string
    field :repo_url, :string
    field :start_date, :utc_datetime
    field :work_status, :string

    belongs_to :creator, User
    belongs_to :project_version, ProjectVersion
    timestamps()
  end

  @doc false
  def changeset(work_project, attrs) do
    work_project
    |> cast(attrs, [:repo_url, :work_status, :public_status, :start_date, :end_date, :description])
    |> validate_required([:repo_url, :work_status, :public_status, :start_date, :end_date, :description])
    |> foreign_key_constraint(:creator_id)
    |> foreign_key_constraint(:project_version_id)
  end
end
