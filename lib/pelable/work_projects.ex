defmodule Pelable.WorkProjects do
  @moduledoc """
  The WorkProject context.
  """

  import Ecto.Query, warn: false
  alias Pelable.Repo

  alias Pelable.WorkProjects.{ProjectVersion, UserStory, WorkProject}
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

  def get_work_project_uuid(uuid), do: Repo.get_by(WorkProject, uuid: uuid)

  # String(uuid) -> Map %{workproject, user_stories}
  # Gets work_project id, returns a map with the work_project and a list of its user stories information
  def show_work_project(uuid) do
    work_project = get_work_project_uuid(uuid) |> Repo.preload([:user_stories])
    user_stories = work_project.user_stories |> UserStory.get_user_stories_info
    %{work_project: work_project, user_stories: user_stories}
  end
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

   # %{"name", "user_id", "short"description", "description" "user_stories"} -> %ProjectVersion{}
  #Gets a map and returns a new project version with a new work project with new associated user stories to it
  #This is the function used to create new projects


   def create_work_project_assoc(attrs = %{}) do
    user_id = Map.get(attrs, "user_id")
    attrs = Map.put_new(attrs, "creator_id", user_id)
    {:ok, project_version} = create_project_version(attrs)
    Map.put(attrs, "project_version_id", project_version.id) |> create_work_project
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


  #The user presses start project and this function is ran
  #%{"user_id", "work_project_id"} -> %WorkProject
  # Forks(Copies) the work_project with the id given, creates a new %WorkProject{} and then it starts it
  def fork_and_start_work_project(%{"user_id" => user_id, "work_project_id" => _work_project_id} = attrs) do
    work_project = fork_work_project(attrs)
    attrs = Map.put(attrs, "work_project_id", work_project.id)
    start_work_project(attrs)
  end


  # %{user_id, id} -> %WorkProject{} || {:error, message}
  # Verifies the user_id can start this project and if so sends data down the pipeline
  def start_work_project(%{"work_project_id" => work_project_id, "user_id" => user_id} = attrs) do
    work_project = get_work_project!(work_project_id)

    if work_project.creator_id == user_id do
      start_work_project(work_project, attrs)

    else
      fork_and_start_work_project(attrs)
    end
  end


  # %WorkProject, %{} -> %WorkProject{}
  # Updates workproject with Id, start_date to utc_now and work_status to "started"

  defp start_work_project(%WorkProject{} = work_project, _attrs) do
    
    current_date = DateTime.utc_now
    params = Map.put(%{}, "start_date", current_date) |> Map.put("work_status", "in progress")
    {:ok, work_project} = update_work_project(work_project, params)
    work_project
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

  

  # %{"work_project_id", %{"user_id"}} -> %WorkProject{}
  # Receives a work_project id and a user id returns a new copy of the work_project with the received one as parent
  def fork_work_project(%{"work_project_id" => work_project_id, "user_id" => user_id} = attrs) do
    work_project = get_work_project!(work_project_id) |> Repo.preload([:user_stories])
    user_stories = work_project.user_stories

    {:ok, new_project_version} = work_project.project_version_id |> ProjectVersion.child |> create_project_version
    new_work_project = work_project |> WorkProject.copy |> Map.put("project_version_id", new_project_version.id) |> Map.put("creator_id", user_id)
    {:ok, new_work_project} = create_work_project(new_work_project)
    
    copy_user_stories_to_work_project(user_stories, new_work_project)
    new_work_project |> Repo.preload([:user_stories])
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


   # %UserStory{}, %WorkProject{} -> %WorkProjectUserStory{}
  #Gets a %UserStory and a %WorkProject and creates the a new UserStory belonging to the WorkProject
  def copy_user_story_to_work_project(%UserStory{} = user_story, %WorkProject{} = work_project) do
    attrs = user_story |> UserStory.copy |> Map.put("work_project_id", work_project.id) 
    UserStory.changeset(%UserStory{}, attrs) |> Repo.insert
  end

  # [%UserStory, ...], %WorkProject -> [%WorkProjectUserStory, ...]
  #Gets a list of user_stories and a %WorkProject{} and create a WorkProjectUserStory for each user story
  def copy_user_stories_to_work_project(user_stories, %WorkProject{} = work_project) when is_list(user_stories) do
    Enum.map(user_stories, &Pelable.WorkProjects.copy_user_story_to_work_project(&1, work_project))
  end

  def create_user_story_for_work_project(%{} = attrs, %WorkProject{} = work_project) do
    Map.put(attrs, "work_project_id", work_project.id) |> create_user_story
  end

  # [%{"title" => "Quora", ...}], %WorkProject{} -> [%WorkProjectUserSTory{}, ... || %{:error, changeset}]
  # Takes a list of user stories and a work project and creates the work_project_user_stories or returns error in same order
  def create_user_stories_for_work_project(user_stories, work_project = %WorkProject{}) when is_list(user_stories) do
    Enum.map(user_stories, &Pelable.WorkProjects.create_user_story_for_work_project(&1, work_project))
  end


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
    |> Repo.insert
  end

  # [%{"title", }, ...] -> [%UserStory, ...]
  # Receives a list of maps with fields from which we return a list of new user stories 
  def create_user_stories(user_stories) when is_list(user_stories) do
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
end