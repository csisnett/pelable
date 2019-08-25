defmodule Pelable.WorkProject do
  @moduledoc """
  The WorkProject context.
  """

  import Ecto.Query, warn: false
  alias Pelable.Repo

  alias Pelable.WorkProject.ProjectVersion

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
end
