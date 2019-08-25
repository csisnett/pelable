defmodule Pelable.WorkProjects do
  @moduledoc """
  The WorkProjects context.
  """

  import Ecto.Query, warn: false
  alias Pelable.Repo

  alias Pelable.WorkProjects.WorkProject

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
end
