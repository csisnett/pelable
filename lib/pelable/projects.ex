defmodule Pelable.Projects do
  @moduledoc """
  The Projects context.
  """

  import Ecto.Query, warn: false
  alias Pelable.Repo

  alias Pelable.Projects.Project
  alias Pelable.WorkProjects
  alias Pelable.WorkProjects.ProjectVersion

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
    # %Project{} _ %ProjectVersion _ %UserStory{}s 
  def create_project(attrs \\ %{}) do
    {:ok, project} = %Project{} |> Project.changeset(attrs) |> Repo.insert
    project_version = %ProjectVersion{project_id: project.id}
    {:ok, project_version} = WorkProjects.create_project_version(project_version, attrs)
    user_stories = WorkProjects.create_user_stories(attrs)
    project_version = Repo.preload(project_version, [:user_stories])
    project_version_changeset = Ecto.Changeset.change(project_version)
    user_stories_project_version_changeset = project_version_changeset |> Ecto.Changeset.put_assoc(:user_stories, user_stories)
    new_project_version = Repo.update(user_stories_project_version_changeset)
    project |> Repo.preload(:versions)
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
