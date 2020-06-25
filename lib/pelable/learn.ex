defmodule Pelable.Learn do
  @moduledoc """
  The Learn context.
  """
  alias __MODULE__

  import Ecto.Query, warn: false
  alias Pelable.Repo

  alias Pelable.Learn.{Goal, Tag}
  alias Pelable.Users.User

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

  alias Pelable.Learn.Workspace

  @doc """
  Returns the list of workspaces.

  ## Examples

      iex> list_workspaces()
      [%Workspace{}, ...]

  """
  def list_workspaces do
    Repo.all(Workspace)
  end

  @doc """
  Gets a single workspace.

  Raises `Ecto.NoResultsError` if the Workspace does not exist.

  ## Examples

      iex> get_workspace!(123)
      %Workspace{}

      iex> get_workspace!(456)
      ** (Ecto.NoResultsError)

  """
  def get_workspace!(id), do: Repo.get!(Workspace, id)

  @doc """
  Creates a workspace.

  ## Examples

      iex> create_workspace(%{field: value})
      {:ok, %Workspace{}}

      iex> create_workspace(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_workspace(attrs \\ %{}) do
    %Workspace{}
    |> Workspace.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a workspace.

  ## Examples

      iex> update_workspace(workspace, %{field: new_value})
      {:ok, %Workspace{}}

      iex> update_workspace(workspace, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_workspace(%Workspace{} = workspace, attrs) do
    workspace
    |> Workspace.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Workspace.

  ## Examples

      iex> delete_workspace(workspace)
      {:ok, %Workspace{}}

      iex> delete_workspace(workspace)
      {:error, %Ecto.Changeset{}}

  """
  def delete_workspace(%Workspace{} = workspace) do
    Repo.delete(workspace)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking workspace changes.

  ## Examples

      iex> change_workspace(workspace)
      %Ecto.Changeset{source: %Workspace{}}

  """
  def change_workspace(%Workspace{} = workspace) do
    Workspace.changeset(workspace, %{})
  end

  alias Pelable.Learn.WorkspaceMember

  @doc """
  Returns the list of workspace_member.

  ## Examples

      iex> list_workspace_member()
      [%WorkspaceMember{}, ...]

  """
  def list_workspace_member do
    Repo.all(WorkspaceMember)
  end

  @doc """
  Gets a single workspace_member.

  Raises `Ecto.NoResultsError` if the Workspace member does not exist.

  ## Examples

      iex> get_workspace_member!(123)
      %WorkspaceMember{}

      iex> get_workspace_member!(456)
      ** (Ecto.NoResultsError)

  """
  def get_workspace_member!(id), do: Repo.get!(WorkspaceMember, id)

  @doc """
  Creates a workspace_member.

  ## Examples

      iex> create_workspace_member(%{field: value})
      {:ok, %WorkspaceMember{}}

      iex> create_workspace_member(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_workspace_member(attrs \\ %{}) do
    %WorkspaceMember{}
    |> WorkspaceMember.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a workspace_member.

  ## Examples

      iex> update_workspace_member(workspace_member, %{field: new_value})
      {:ok, %WorkspaceMember{}}

      iex> update_workspace_member(workspace_member, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_workspace_member(%WorkspaceMember{} = workspace_member, attrs) do
    workspace_member
    |> WorkspaceMember.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a WorkspaceMember.

  ## Examples

      iex> delete_workspace_member(workspace_member)
      {:ok, %WorkspaceMember{}}

      iex> delete_workspace_member(workspace_member)
      {:error, %Ecto.Changeset{}}

  """
  def delete_workspace_member(%WorkspaceMember{} = workspace_member) do
    Repo.delete(workspace_member)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking workspace_member changes.

  ## Examples

      iex> change_workspace_member(workspace_member)
      %Ecto.Changeset{source: %WorkspaceMember{}}

  """
  def change_workspace_member(%WorkspaceMember{} = workspace_member) do
    WorkspaceMember.changeset(workspace_member, %{})
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

  alias Pelable.Learn.Section

  @doc """
  Returns the list of sections.

  ## Examples

      iex> list_sections()
      [%Section{}, ...]

  """
  def list_sections do
    Repo.all(Section)
  end

  @doc """
  Gets a single section.

  Raises `Ecto.NoResultsError` if the Section does not exist.

  ## Examples

      iex> get_section!(123)
      %Section{}

      iex> get_section!(456)
      ** (Ecto.NoResultsError)

  """
  def get_section!(id), do: Repo.get!(Section, id)

  @doc """
  Creates a section.

  ## Examples

      iex> create_section(%{field: value})
      {:ok, %Section{}}

      iex> create_section(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_section(attrs \\ %{}) do
    %Section{}
    |> Section.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a section.

  ## Examples

      iex> update_section(section, %{field: new_value})
      {:ok, %Section{}}

      iex> update_section(section, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_section(%Section{} = section, attrs) do
    section
    |> Section.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Section.

  ## Examples

      iex> delete_section(section)
      {:ok, %Section{}}

      iex> delete_section(section)
      {:error, %Ecto.Changeset{}}

  """
  def delete_section(%Section{} = section) do
    Repo.delete(section)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking section changes.

  ## Examples

      iex> change_section(section)
      %Ecto.Changeset{source: %Section{}}

  """
  def change_section(%Section{} = section) do
    Section.changeset(section, %{})
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
end
