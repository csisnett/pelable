defmodule Pelable.Projects do
  @moduledoc """
  The Projects context.
  """

  import Ecto.Query, warn: false
  alias Pelable.Repo

  alias Pelable.Projects.Project
  alias Pelable.WorkProjects
  alias Pelable.WorkProjects.{WorkProject, ProjectVersion}

  @doc """
  Returns the list of projects.

  ## Examples

      iex> list_projects()
      [%Project{}, ...]

  """
  def list_projects do
    Repo.all(Project)
  end

  @doc """
  Gets a single project.

  Raises `Ecto.NoResultsError` if the Project does not exist.

  ## Examples

      iex> get_project!(123)
      %Project{}

      iex> get_project!(456)
      ** (Ecto.NoResultsError)

  """
  def get_project!(id), do: Repo.get!(Project, id)

  @doc """
  Creates a project.

  ## Examples

      iex> create_project(%{field: value})
      {:ok, %Project{}}

      iex> create_project(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  #%{"creator_id", "description", "name", "public_status", "user_stories" => [%{body => "do X", %{"body" => "do Y"}}] } -> 
    #  -> %Project{} & %ProjectVersion & %UserStory{}s 
  # %{"user_id" => 1,  "description" => "a project", "name" => "mi prmero", "public_status" => "public", "user_stories" => [%{"title" => "hola"}, %{"title" => "waa"}, %{"title" => "amen"}]}
  def create_project(attrs \\ %{}) do
    #{:ok, project} = %Project{} |> Project.changeset(attrs) |> Repo.insert
    #project_version = %ProjectVersion{project_id: project.id}
    user_id = Map.get(attrs, "user_id")
    attrs = Map.put(attrs, "creator_id", user_id) |> Map.put("added_by_id", user_id)
    {:ok, project_version} = WorkProjects.create_project_version(attrs)
    attrs = Map.put(attrs, "project_version_id", project_version.id)
    {:ok, work_project} = WorkProjects.create_work_project(attrs)
    user_stories = WorkProjects.create_user_stories(attrs)
    work_project = Repo.preload(work_project, [:user_stories])
    work_project_changeset = Ecto.Changeset.change(work_project)
    user_stories_work_project_changeset = work_project_changeset |> Ecto.Changeset.put_assoc(:user_stories, user_stories)
    new_work_project = Repo.update(user_stories_work_project_changeset)
    project_version |> Repo.preload([:work_projects])
    #project_version = Repo.preload(project_version, [:user_stories])
    #project_version_changeset = Ecto.Changeset.change(project_version)
    #user_stories_project_version_changeset = project_version_changeset |> Ecto.Changeset.put_assoc(:user_stories, user_stories)
    #new_project_version = Repo.update(user_stories_project_version_changeset)
    #project |> Repo.preload(:versions)
  end

  @doc """
  Updates a project.

  ## Examples

      iex> update_project(project, %{field: new_value})
      {:ok, %Project{}}

      iex> update_project(project, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_project(%Project{} = project, attrs) do
    project
    |> Project.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Project.

  ## Examples

      iex> delete_project(project)
      {:ok, %Project{}}

      iex> delete_project(project)
      {:error, %Ecto.Changeset{}}

  """
  def delete_project(%Project{} = project) do
    Repo.delete(project)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking project changes.

  ## Examples

      iex> change_project(project)
      %Ecto.Changeset{source: %Project{}}

  """
  def change_project(%Project{} = project) do
    Project.changeset(project, %{})
  end
end
