defmodule Pelable.WorkProjects do
  @moduledoc """
  The WorkProject context.
  """

  import Ecto.Query, warn: false
  alias Pelable.Repo

  alias Pelable.WorkProjects.{ProjectVersion, UserStory, WorkProject}
  alias Pelable.WorkProjects.WorkProjectUserStory
  alias Pelable.WorkProjects

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

  def create_work_project_version(attrs = %{}) do
    user_id = Map.get(attrs, "user_id")
    attrs = Map.put(attrs, "creator_id", user_id) |> Map.put("added_by_id", user_id)
    {:ok, project_version} = create_project_version(attrs)
    attrs = Map.put(attrs, "project_version_id", project_version.id)
    {:ok, work_project} = create_work_project(attrs)
    user_stories = create_user_stories(attrs)
    add_user_stories_work_project(user_stories, work_project)
    project_version |> Repo.preload([:work_projects])
  end

  def create_project_version(%ProjectVersion{} = project_version, %{} = attrs) do
    project_version
    |> ProjectVersion.changeset(attrs)
    |> Repo.insert()
  end

  # %{"creator_id", %{"project_version_id"}} -> %ProjectVersion
  # gets a request from a user returns a new project version with the previous one as parent
  def fork_project_version(%{} = attrs) do
    project_version_id = Map.get(attrs, "project_version_id")
    creator_id = Map.get(attrs, "creator_id")

    project_version = get_project_version!(project_version_id) |> Repo.preload([:creator, :parent, :project, :bookmarked_by, :user_stories])
    new_project_version = %{} |> Map.put("name", project_version.name) |> Map.put("description", project_version.description) |> Map.put("public_status", project_version.public_status) |> Map.put("creator_id", creator_id) |> Map.put("first?", false) |> Map.put("parent_id", project_version.id) 
    {:ok, new_project_version} = create_project_version(new_project_version)
    user_stories_changeset = new_project_version |> Repo.preload([:user_stories]) |> Ecto.Changeset.change |> Ecto.Changeset.put_assoc(:user_stories, project_version.user_stories)
    Repo.update(user_stories_changeset)
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

  def get_insert_user_story(changeset, true) do
    existing_user_story = Repo.get_by(UserStory, title: changeset.changes.title)

    case existing_user_story do
      nil -> Repo.insert(changeset)
      user_story -> user_story
    end
  end

  def get_insert_user_story(changeset, false) do
    {:error, changeset}
  end

  def create_user_story(attrs \\ %{}) do
    changeset = %UserStory{} |> UserStory.changeset(attrs)
    
    case get_insert_user_story(changeset, changeset.valid?) do
      {:ok, u} -> u
      u -> u
    end
  end

  def create_user_stories(%{"user_stories" => user_stories}) do
    Enum.map(user_stories, &Pelable.WorkProjects.create_user_story/1)
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

  def add_user_story_work_project(%UserStory{} = user_story, %WorkProject{} = work_project) do
    {:ok, work_project_user_story} = Map.put(%{}, "user_story_id", user_story.id) |> Map.put("work_project_id", work_project.id) |> create_work_project_user_story
    work_project_user_story
  end

  def add_user_stories_work_project(user_stories, %WorkProject{} = work_project) when is_list(user_stories) do
    Enum.each(user_stories, &Pelable.WorkProjects.add_user_story_work_project(&1, work_project))
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
