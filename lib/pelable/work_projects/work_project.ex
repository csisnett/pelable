defmodule Pelable.WorkProjects.WorkProject do
  use Ecto.Schema
  import Ecto.Changeset

  alias Pelable.Users.User
  alias Pelable.WorkProjects.{WorkProject, ProjectVersion, UserStory}

  schema "work_projects" do
    field :name, :string
    field :description, :string
    field :end_date, :utc_datetime
    field :public_status, :string, default: "public"
    field :repo_url, :string
    field :start_date, :utc_datetime, default: ~U[1000-01-01 11:11:00Z]
    field :work_status, :string, default: "not started"

    belongs_to :creator, User
    belongs_to :project_version, ProjectVersion
    many_to_many :user_stories, UserStory, join_through: "work_project_user_story"
    timestamps()
  end

  @doc false
  def changeset(work_project, attrs) do
    work_project
    |> cast(attrs, [:creator_id, :work_status, :public_status, :start_date, :end_date, :description, :project_version_id])
    |> validate_required([:creator_id, :work_status, :public_status, :project_version_id])
    |> foreign_key_constraint(:creator_id)
    |> foreign_key_constraint(:project_version_id)
  end
end
