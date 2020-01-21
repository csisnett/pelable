defmodule Pelable.Learn do
  @moduledoc """
  The Learn context.
  """

  import Ecto.Query, warn: false
  alias Pelable.Repo

  alias Pelable.Learn.{Goal, Tag}
  alias Pelable.Users.User

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
  def delete_chatroom(%User{} = user) do
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
  @doc """
  Returns the list of goals.

  ## Examples

      iex> list_goals()
      [%Goal{}, ...]

  """
  def list_goals do
    Repo.all(Goal)
  end

  @doc """
  Gets a single goal.

  Raises `Ecto.NoResultsError` if the Goal does not exist.

  ## Examples

      iex> get_goal!(123)
      %Goal{}

      iex> get_goal!(456)
      ** (Ecto.NoResultsError)

  """
  def get_goal!(id), do: Repo.get!(Goal, id)

  @doc """
  Creates a goal.

  ## Examples

      iex> create_goal(%{field: value})
      {:ok, %Goal{}}

      iex> create_goal(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_goal(attrs \\ %{}) do
    %Goal{}
    |> Goal.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a goal.

  ## Examples

      iex> update_goal(goal, %{field: new_value})
      {:ok, %Goal{}}

      iex> update_goal(goal, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_goal(%Goal{} = goal, attrs) do
    goal
    |> Goal.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Goal.

  ## Examples

      iex> delete_goal(goal)
      {:ok, %Goal{}}

      iex> delete_goal(goal)
      {:error, %Ecto.Changeset{}}

  """
  def delete_goal(%Goal{} = goal) do
    Repo.delete(goal)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking goal changes.

  ## Examples

      iex> change_goal(goal)
      %Ecto.Changeset{source: %Goal{}}

  """
  def change_goal(%Goal{} = goal) do
    Goal.changeset(goal, %{})
  end

  alias Pelable.Learn.Tag

  @doc """
  Returns the list of tags.

  ## Examples

      iex> list_tags()
      [%Tag{}, ...]

  """
  def list_tags do
    Repo.all(Tag)
  end

  @doc """
  Gets a single tag.

  Raises `Ecto.NoResultsError` if the Tag does not exist.

  ## Examples

      iex> get_tag!(123)
      %Tag{}

      iex> get_tag!(456)
      ** (Ecto.NoResultsError)

  """
  def get_tag!(id), do: Repo.get!(Tag, id)

  @doc """
  Creates a tag.

  ## Examples

      iex> create_tag(%{field: value})
      {:ok, %Tag{}}

      iex> create_tag(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_tag(attrs \\ %{}) do
    %Tag{}
    |> Tag.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a tag.

  ## Examples

      iex> update_tag(tag, %{field: new_value})
      {:ok, %Tag{}}

      iex> update_tag(tag, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_tag(%Tag{} = tag, attrs) do
    tag
    |> Tag.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Tag.

  ## Examples

      iex> delete_tag(tag)
      {:ok, %Tag{}}

      iex> delete_tag(tag)
      {:error, %Ecto.Changeset{}}

  """
  def delete_tag(%Tag{} = tag) do
    Repo.delete(tag)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking tag changes.

  ## Examples

      iex> change_tag(tag)
      %Ecto.Changeset{source: %Tag{}}

  """
  def change_tag(%Tag{} = tag) do
    Tag.changeset(tag, %{})
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
end
