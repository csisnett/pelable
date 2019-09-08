defmodule Pelable.WorkProjects.WorkProject do
  use Ecto.Schema
  import Ecto.Changeset
  
  alias Pelable.Users.User
  alias Pelable.WorkProjects.{WorkProject, ProjectVersion, UserStory, WorkProjectUserStory, NameSlug}

  schema "work_projects" do
    field :name, :string
    field :slug, NameSlug.Type
    field :short_description, :string
    field :description, :string
    field :description_html, :string
    field :description_markdown, :string, virtual: true
    field :start_date, :utc_datetime, default: ~U[1000-01-01 11:11:00Z]
    field :end_date, :utc_datetime
    field :repo_url, :string
    field :show_url, :string
    field :public_status, :string, default: "public"
    field :work_status, :string, default: "not started"
    field :uuid, :string

    has_many :work_user_stories, WorkProjectUserStory
    belongs_to :creator, User
    belongs_to :project_version, ProjectVersion
    many_to_many :user_stories, UserStory, join_through: "work_project_user_story"
    timestamps()
  end


  def generate_random_uuid(length) do
    :crypto.strong_rand_bytes(length) |> Base.url_encode64 |> binary_part(0, length)
  end

  def markdown_to_html(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{description_markdown: description}} ->
        put_change(changeset, :description_html, Earmark.as_html!(description))
      _ ->
        changeset
    end
  end

  def generate_uuid(changeset) do
    case get_field(changeset, :uuid) do
      nil -> changeset |> put_change(:uuid, generate_random_uuid(12))
      _ -> changeset
    end
  end

  @doc false
  def changeset(work_project, attrs) do
    work_project
    |> cast(attrs, [:name, :short_description, :description, :description_html, :description_markdown, :creator_id, :work_status, :public_status, :start_date, :end_date, :project_version_id, :repo_url, :show_url])
    |> validate_required([:name, :creator_id, :work_status, :public_status, :start_date, :project_version_id])
    |> foreign_key_constraint(:creator_id)
    |> foreign_key_constraint(:project_version_id)
    |> unique_constraint(:uuid)
    |> markdown_to_html
    |> generate_uuid
    |> NameSlug.maybe_generate_slug
  end
end
