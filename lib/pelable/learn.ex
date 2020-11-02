defmodule Pelable.Learn do
  @moduledoc """
  The Learn context.
  """
  alias __MODULE__

  import Ecto.Query, warn: false
  alias Pelable.Repo

  alias Pelable.Learn.{Workspace, Goal, Tag, WorkspaceMember}
  alias Pelable.Users.User
  alias Pelable.Chat

  defdelegate authorize(action, user, params), to: Pelable.Learn.Policy

  def list_users do
    Repo.all(User)
  end

  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  def get_user_by_username(username) do
    Repo.get_by(User, username: username)
  end

  def get_user!(id), do: Repo.get!(User, id)


  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  def update_user_email(%User{} = user, %{"email" => _} = attrs) do
    user
    |> User.changeset_email(attrs)
    |> Repo.update()
  end

 

  @doc """
  Deletes a user.

  ## Examples

      iex> delete_user(user)
      {:ok, %user{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{source: %User}}

  """
  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end

  alias Pelable.Learn.Project

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
  def create_project(attrs \\ %{}) do
    %Project{}
    |> Project.changeset(attrs)
    |> Repo.insert()
  end

  #Creates a new project for the user given
  # %{"name", "description"}, %User{} -> %Project{}
  def create_project(%{} = project_params, %User{} = user) do
    {:ok, project} = project_params |> Map.put("creator_id", user.id) |> create_project
    {:ok, _project_member} = create_project_member(%{"user_id" => user.id, "project_id" => project.id})
    project
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

  alias Pelable.Learn.ProjectMember


  def get_projects(%User{} = user) do
    query = from pm in ProjectMember,
    where: pm.user_id == ^user.id,
    join: p in Project,
    on: p.id == pm.project_id,
    select: p
    Repo.all(query)
  end

  def create_project_member(attrs \\ %{}) do
    %ProjectMember{}
    |> ProjectMember.changeset(attrs)
    |> Repo.insert()
  end

  def update_project_member(%ProjectMember{} = project_member, attrs) do
    project_member
    |> ProjectMember.changeset(attrs)
    |> Repo.update()
  end


  def delete_project_member(%ProjectMember{} = project_member) do
    Repo.delete(project_member)
  end

  def change_project_member(%ProjectMember{} = project_member) do
    ProjectMember.changeset(project_member, %{})
  end



  alias Pelable.Learn.Post

  @doc """
  Returns the list of posts.

  ## Examples

      iex> list_posts()
      [%Post{}, ...]

  """
  def list_posts do
    Repo.all(Post)
  end

  # %User{} -> [%Post{}, ...]
  def list_user_posts(%User{} = user) do
    query = 
    from p in Post,
    where: p.creator_id == ^user.id,
    select: p
    Repo.all(query)
  end

  @doc """
  Gets a single post.

  Raises `Ecto.NoResultsError` if the Post does not exist.

  ## Examples

      iex> get_post!(123)
      %Post{}

      iex> get_post!(456)
      ** (Ecto.NoResultsError)

  """
  def get_post!(id), do: Repo.get!(Post, id)

  def get_post_by_uuid(uuid), do: Repo.get_by(Post, uuid: uuid)

  @doc """
  Creates a post.

  ## Examples

      iex> create_post(%{field: value})
      {:ok, %Post{}}

      iex> create_post(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_post(attrs \\ %{}, user) do
    with :ok <- Bodyguard.permit(Learn.Policy, :create_post, user, %Post{})
    do
      %Post{}
      |> Post.changeset(attrs)
      |> Repo.insert()
    end
  end

  @doc """
  Updates a post.

  ## Examples

      iex> update_post(post, %{field: new_value})
      {:ok, %Post{}}

      iex> update_post(post, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_post(%Post{} = post, user, attrs) do
    case Bodyguard.permit(Learn.Policy, :update_post, user, post) do
    :ok -> 
    post
    |> Post.changeset(attrs)
    |> Repo.update()
    _ ->
    end
  end

  @doc """
  Deletes a Post.

  ## Examples

      iex> delete_post(post)
      {:ok, %Post{}}

      iex> delete_post(post)
      {:error, %Ecto.Changeset{}}

  """
  def delete_post(%Post{} = post, user) do
    with :ok <- Bodyguard.permit(Learn.Policy, :delete_post, user, post)
    do
    Repo.delete(post)
    end
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking post changes.

  ## Examples

      iex> change_post(post)
      %Ecto.Changeset{source: %Post{}}

  """
  def change_post(%Post{} = post) do
    Post.changeset(post, %{})
  end

  alias Pelable.Learn.Thread

  @doc """
  Returns the list of threads.

  ## Examples

      iex> list_threads()
      [%Thread{}, ...]

  """
  def list_threads do
    Repo.all(Thread)
  end

  @doc """
  Gets a single thread.

  Raises `Ecto.NoResultsError` if the Thread does not exist.

  ## Examples

      iex> get_thread!(123)
      %Thread{}

      iex> get_thread!(456)
      ** (Ecto.NoResultsError)

  """
  def get_thread!(id), do: Repo.get!(Thread, id)

  @doc """
  Creates a thread.

  ## Examples

      iex> create_thread(%{field: value})
      {:ok, %Thread{}}

      iex> create_thread(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_thread(attrs \\ %{}) do
    %Thread{}
    |> Thread.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a thread.

  ## Examples

      iex> update_thread(thread, %{field: new_value})
      {:ok, %Thread{}}

      iex> update_thread(thread, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_thread(%Thread{} = thread, attrs) do
    thread
    |> Thread.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Thread.

  ## Examples

      iex> delete_thread(thread)
      {:ok, %Thread{}}

      iex> delete_thread(thread)
      {:error, %Ecto.Changeset{}}

  """
  def delete_thread(%Thread{} = thread) do
    Repo.delete(thread)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking thread changes.

  ## Examples

      iex> change_thread(thread)
      %Ecto.Changeset{source: %Thread{}}

  """
  def change_thread(%Thread{} = thread) do
    Thread.changeset(thread, %{})
  end

  alias Pelable.Learn.ThreadPost

  @doc """
  Returns the list of thread_posts.

  ## Examples

      iex> list_thread_posts()
      [%ThreadPost{}, ...]

  """
  def list_thread_posts do
    Repo.all(ThreadPost)
  end

  @doc """
  Gets a single thread_post.

  Raises `Ecto.NoResultsError` if the Thread post does not exist.

  ## Examples

      iex> get_thread_post!(123)
      %ThreadPost{}

      iex> get_thread_post!(456)
      ** (Ecto.NoResultsError)

  """
  def get_thread_post!(id), do: Repo.get!(ThreadPost, id)

  @doc """
  Creates a thread_post.

  ## Examples

      iex> create_thread_post(%{field: value})
      {:ok, %ThreadPost{}}

      iex> create_thread_post(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_thread_post(attrs \\ %{}) do
    %ThreadPost{}
    |> ThreadPost.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a thread_post.

  ## Examples

      iex> update_thread_post(thread_post, %{field: new_value})
      {:ok, %ThreadPost{}}

      iex> update_thread_post(thread_post, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_thread_post(%ThreadPost{} = thread_post, attrs) do
    thread_post
    |> ThreadPost.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a ThreadPost.

  ## Examples

      iex> delete_thread_post(thread_post)
      {:ok, %ThreadPost{}}

      iex> delete_thread_post(thread_post)
      {:error, %Ecto.Changeset{}}

  """
  def delete_thread_post(%ThreadPost{} = thread_post) do
    Repo.delete(thread_post)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking thread_post changes.

  ## Examples

      iex> change_thread_post(thread_post)
      %Ecto.Changeset{source: %ThreadPost{}}

  """
  def change_thread_post(%ThreadPost{} = thread_post) do
    ThreadPost.changeset(thread_post, %{})
  end

  alias Pelable.Learn.Task

  @doc """
  Returns the list of tasks.

  ## Examples

      iex> list_tasks()
      [%Task{}, ...]

  """
  def list_tasks do
    Repo.all(Task)
  end

  @doc """
  Gets a single task.

  Raises `Ecto.NoResultsError` if the Task does not exist.

  ## Examples

      iex> get_task!(123)
      %Task{}

      iex> get_task!(456)
      ** (Ecto.NoResultsError)

  """
  def get_task!(id), do: Repo.get!(Task, id)

  # uuid -> %Task{}
  # Returns the task with the uuid given
  def get_task_by_uuid(uuid), do: Repo.get_by(Task, uuid: uuid)

  @doc """
  Creates a task.

  ## Examples

      iex> create_task(%{field: value})
      {:ok, %Task{}}

      iex> create_task(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_task(attrs \\ %{}) do
    %Task{}
    |> Task.changeset(attrs)
    |> Repo.insert()
  end

  # %{}, %User{} -> %Task{}
  # Creates a new Task from the params and user given
  def create_task(%{} = attrs, %User{} = user) do
    with :ok <- Bodyguard.permit(Learn.Policy, :create_task, user, %Task{}) do
      attrs |> Map.put("creator_id", user.id) |> create_task
    end
  end

  @doc """
  Updates a task.

  ## Examples

      iex> update_task(task, %{field: new_value})
      {:ok, %Task{}}

      iex> update_task(task, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_task(%Task{} = task, attrs) do
    task
    |> Task.changeset(attrs)
    |> Repo.update()
  end


  # %{}, %User{} -> %Task{}
  # Updates a user's Task with the params given
  def update_task(%{"uuid" => uuid} = attrs, %User{} = user) do
    task = get_task_by_uuid(uuid)
    with :ok <- Bodyguard.permit(Learn.Policy, :update_task, user, task) do
      update_task(task, attrs)
    end
  end

  @doc """
  Deletes a task.

  ## Examples

      iex> delete_task(task)
      {:ok, %Task{}}

      iex> delete_task(task)
      {:error, %Ecto.Changeset{}}

  """
  def delete_task(%Task{} = task) do
    Repo.delete(task)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking task changes.

  ## Examples

      iex> change_task(task)
      %Ecto.Changeset{data: %Task{}}

  """
  def change_task(%Task{} = task, attrs \\ %{}) do
    Task.changeset(task, attrs)
  end
end
