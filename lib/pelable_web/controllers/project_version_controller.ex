defmodule PelableWeb.ProjectVersionController do
  use PelableWeb, :controller

  alias Pelable.WorkProject
  alias Pelable.WorkProject.ProjectVersion

  def index(conn, _params) do
    project_versions = WorkProject.list_project_versions()
    render(conn, "index.html", project_versions: project_versions)
  end

  def new(conn, _params) do
    changeset = WorkProject.change_project_version(%ProjectVersion{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"project_version" => project_version_params}) do
    case WorkProject.create_project_version(project_version_params) do
      {:ok, project_version} ->
        conn
        |> put_flash(:info, "Project version created successfully.")
        |> redirect(to: Routes.project_version_path(conn, :show, project_version))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    project_version = WorkProject.get_project_version!(id)
    render(conn, "show.html", project_version: project_version)
  end

  def edit(conn, %{"id" => id}) do
    project_version = WorkProject.get_project_version!(id)
    changeset = WorkProject.change_project_version(project_version)
    render(conn, "edit.html", project_version: project_version, changeset: changeset)
  end

  def update(conn, %{"id" => id, "project_version" => project_version_params}) do
    project_version = WorkProject.get_project_version!(id)

    case WorkProject.update_project_version(project_version, project_version_params) do
      {:ok, project_version} ->
        conn
        |> put_flash(:info, "Project version updated successfully.")
        |> redirect(to: Routes.project_version_path(conn, :show, project_version))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", project_version: project_version, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    project_version = WorkProject.get_project_version!(id)
    {:ok, _project_version} = WorkProject.delete_project_version(project_version)

    conn
    |> put_flash(:info, "Project version deleted successfully.")
    |> redirect(to: Routes.project_version_path(conn, :index))
  end
end
