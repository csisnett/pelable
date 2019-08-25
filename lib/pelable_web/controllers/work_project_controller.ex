defmodule PelableWeb.WorkProjectController do
  use PelableWeb, :controller

  alias Pelable.WorkProject
  alias Pelable.WorkProject.WorkProject

  def index(conn, _params) do
    work_projects = WorkProject.list_work_projects()
    render(conn, "index.html", work_projects: work_projects)
  end

  def new(conn, _params) do
    changeset = WorkProject.change_work_project(%WorkProject{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"work_project" => work_project_params}) do
    case WorkProject.create_work_project(work_project_params) do
      {:ok, work_project} ->
        conn
        |> put_flash(:info, "Work project created successfully.")
        |> redirect(to: Routes.work_project_path(conn, :show, work_project))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    work_project = WorkProject.get_work_project!(id)
    render(conn, "show.html", work_project: work_project)
  end

  def edit(conn, %{"id" => id}) do
    work_project = WorkProject.get_work_project!(id)
    changeset = WorkProject.change_work_project(work_project)
    render(conn, "edit.html", work_project: work_project, changeset: changeset)
  end

  def update(conn, %{"id" => id, "work_project" => work_project_params}) do
    work_project = WorkProject.get_work_project!(id)

    case WorkProject.update_work_project(work_project, work_project_params) do
      {:ok, work_project} ->
        conn
        |> put_flash(:info, "Work project updated successfully.")
        |> redirect(to: Routes.work_project_path(conn, :show, work_project))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", work_project: work_project, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    work_project = WorkProject.get_work_project!(id)
    {:ok, _work_project} = WorkProject.delete_work_project(work_project)

    conn
    |> put_flash(:info, "Work project deleted successfully.")
    |> redirect(to: Routes.work_project_path(conn, :index))
  end
end
