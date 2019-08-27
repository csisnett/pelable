defmodule Pelable.WorkProjects do
  @moduledoc """
  The WorkProject context.
  """

  import Ecto.Query, warn: false
  alias Pelable.Repo

  alias Pelable.WorkProjects.{ProjectVersion, UserStory, WorkProject}
  @doc """
  Returns the list of work_projects.

  ## Examples

      iex> list_work_projects()
      [%WorkProject{}, ...]

  """
  def list_work_projects do
    Repo.all(WorkProject)
  end

  @doc """
  Gets a single work_project.

  Raises `Ecto.NoResultsError` if the Work project does not exist.

  ## Examples

      iex> get_work_project!(123)
      %WorkProject{}

      iex> get_work_project!(456)
      ** (Ecto.NoResultsError)

  """
  def get_work_project!(id), do: Repo.get!(WorkProject, id)

  @doc """
  Creates a work_project.

  ## Examples

      iex> create_work_project(%{field: value})
      {:ok, %WorkProject{}}

      iex> create_work_project(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_work_project(attrs \\ %{}) do
    %WorkProject{}
    |> WorkProject.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a work_project.

  ## Examples

      iex> update_work_project(work_project, %{field: new_value})
      {:ok, %WorkProject{}}

      iex> update_work_project(work_project, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_work_project(%WorkProject{} = work_project, attrs) do
    work_project
    |> WorkProject.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a WorkProject.

  ## Examples

      iex> delete_work_project(work_project)
      {:ok, %WorkProject{}}

      iex> delete_work_project(work_project)
      {:error, %Ecto.Changeset{}}

  """
  def delete_work_project(%WorkProject{} = work_project) do
    Repo.delete(work_project)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking work_project changes.

  ## Examples

      iex> change_work_project(work_project)
      %Ecto.Changeset{source: %WorkProject{}}

  """
  def change_work_project(%WorkProject{} = work_project) do
    WorkProject.changeset(work_project, %{})
  end

  @doc """
  Returns the list of project_versions.

  ## Examples

      iex> list_project_versions()
      [%ProjectVersion{}, ...]

  """
  def list_project_versions do
    Repo.all(ProjectVersion)
  end

  @doc """
  Gets a single project_version.

  Raises `Ecto.NoResultsError` if the Project version does not exist.

  ## Examples

      iex> get_project_version!(123)
      %ProjectVersion{}

      iex> get_project_version!(456)
      ** (Ecto.NoResultsError)

  """
  def get_project_version!(id), do: Repo.get!(ProjectVersion, id)

  @doc """
  Creates a project_version.

  ## Examples

      iex> create_project_version(%{field: value})
      {:ok, %ProjectVersion{}}

      iex> create_project_version(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_project_version(attrs \\ %{}) do
    %ProjectVersion{}
    |> ProjectVersion.changeset(attrs)
    |> Repo.insert()
  end

  def create_project_version(%ProjectVersion{} = project_version, %{} = attrs) do
    project_version
    |> ProjectVersion.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a project_version.

  ## Examples

      iex> update_project_version(project_version, %{field: new_value})
      {:ok, %ProjectVersion{}}

      iex> update_project_version(project_version, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_project_version(%ProjectVersion{} = project_version, attrs) do
    project_version
    |> ProjectVersion.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a ProjectVersion.

  ## Examples

      iex> delete_project_version(project_version)
      {:ok, %ProjectVersion{}}

      iex> delete_project_version(project_version)
      {:error, %Ecto.Changeset{}}

  """
  def delete_project_version(%ProjectVersion{} = project_version) do
    Repo.delete(project_version)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking project_version changes.

  ## Examples

      iex> change_project_version(project_version)
      %Ecto.Changeset{source: %ProjectVersion{}}

  """
  def change_project_version(%ProjectVersion{} = project_version) do
    ProjectVersion.changeset(project_version, %{})
  end

  @doc """
  Returns the list of user_stories.

  ## Examples

      iex> list_user_stories()
      [%UserStory{}, ...]

  """
  def list_user_stories do
    Repo.all(UserStory)
  end

  @doc """
  Gets a single user_story.

  Raises `Ecto.NoResultsError` if the User story does not exist.

  ## Examples

      iex> get_user_story!(123)
      %UserStory{}

      iex> get_user_story!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user_story!(id), do: Repo.get!(UserStory, id)

  @doc """
  Creates a user_story.

  ## Examples

      iex> create_user_story(%{field: value})
      {:ok, %UserStory{}}

      iex> create_user_story(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user_story(attrs \\ %{}) do
    %UserStory{}
    |> UserStory.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user_story.

  ## Examples

      iex> update_user_story(user_story, %{field: new_value})
      {:ok, %UserStory{}}

      iex> update_user_story(user_story, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user_story(%UserStory{} = user_story, attrs) do
    user_story
    |> UserStory.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a UserStory.

  ## Examples

      iex> delete_user_story(user_story)
      {:ok, %UserStory{}}

      iex> delete_user_story(user_story)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user_story(%UserStory{} = user_story) do
    Repo.delete(user_story)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user_story changes.

  ## Examples

      iex> change_user_story(user_story)
      %Ecto.Changeset{source: %UserStory{}}

  """
  def change_user_story(%UserStory{} = user_story) do
    UserStory.changeset(user_story, %{})
  end

  alias Pelable.WorkProjects.WorkProjectUserStory

  @doc """
  Returns the list of work_project_user_story.

  ## Examples

      iex> list_work_project_user_story()
      [%WorkProjectUserStory{}, ...]

  """
  def list_work_project_user_story do
    Repo.all(WorkProjectUserStory)
  end

  @doc """
  Gets a single work_project_user_story.

  Raises `Ecto.NoResultsError` if the Work project user story does not exist.

  ## Examples

      iex> get_work_project_user_story!(123)
      %WorkProjectUserStory{}

      iex> get_work_project_user_story!(456)
      ** (Ecto.NoResultsError)

  """
  def get_work_project_user_story!(id), do: Repo.get!(WorkProjectUserStory, id)

  @doc """
  Creates a work_project_user_story.

  ## Examples

      iex> create_work_project_user_story(%{field: value})
      {:ok, %WorkProjectUserStory{}}

      iex> create_work_project_user_story(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_work_project_user_story(attrs \\ %{}) do
    %WorkProjectUserStory{}
    |> WorkProjectUserStory.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a work_project_user_story.

  ## Examples

      iex> update_work_project_user_story(work_project_user_story, %{field: new_value})
      {:ok, %WorkProjectUserStory{}}

      iex> update_work_project_user_story(work_project_user_story, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_work_project_user_story(%WorkProjectUserStory{} = work_project_user_story, attrs) do
    work_project_user_story
    |> WorkProjectUserStory.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a WorkProjectUserStory.

  ## Examples

      iex> delete_work_project_user_story(work_project_user_story)
      {:ok, %WorkProjectUserStory{}}

      iex> delete_work_project_user_story(work_project_user_story)
      {:error, %Ecto.Changeset{}}

  """
  def delete_work_project_user_story(%WorkProjectUserStory{} = work_project_user_story) do
    Repo.delete(work_project_user_story)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking work_project_user_story changes.

  ## Examples

      iex> change_work_project_user_story(work_project_user_story)
      %Ecto.Changeset{source: %WorkProjectUserStory{}}

  """
  def change_work_project_user_story(%WorkProjectUserStory{} = work_project_user_story) do
    WorkProjectUserStory.changeset(work_project_user_story, %{})
  end
end
