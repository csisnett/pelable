defmodule Pelable.WorkProject.WorkProject do
  use Ecto.Schema
  import Ecto.Changeset

  alias Pelable.Users.User

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
  end
end
