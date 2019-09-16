defmodule PelableWeb.WorkProjectController do
  use PelableWeb, :controller

  alias Pelable.WorkProjects
  alias Pelable.WorkProjects.WorkProject
  alias Pelable.Repo

  def index(conn, _params) do
    work_projects = WorkProjects.list_work_projects()
    render(conn, "index.html", work_projects: work_projects)
  end

  def new(conn, _params) do
    changeset = WorkProjects.change_work_project(%WorkProject{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"work_project" => work_project_params}) do
    work_project_params = Map.put(work_project_params, "user_id", conn.assigns.current_user.id)
    case WorkProjects.create_work_project_assoc(work_project_params) do
      {:ok, work_project} ->
        conn
        |> put_flash(:info, "Project created successfully.")
        |> redirect(to: Routes.work_project_path(conn, :show, work_project.slug, work_project.uuid))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def start(conn, %{"uuid" => uuid} = work_project_params) do
    case WorkProjects.get_work_project_uuid(uuid) do
      work_project ->
        params = %{"work_project_id" => work_project.id, "user_id" => conn.assigns.current_user.id}
        work_project = WorkProjects.start_work_project(params)
        conn
        |> put_flash(:info, "You started this Project successfully!")
        |> redirect(to: Routes.work_project_path(conn, :show, work_project.slug, work_project.uuid))
      end
  end

  def show(conn, %{"uuid" => uuid}) do
    work_project = WorkProjects.get_work_project_uuid(uuid) |> Repo.preload([:user_stories])
    render(conn, "show.html", work_project: work_project)
  end

  def edit(conn, %{"id" => id}) do
    work_project = WorkProjects.get_work_project!(id)
    changeset = WorkProjects.change_work_project(work_project)
    render(conn, "edit.html", work_project: work_project, changeset: changeset)
  end

  def update(conn, %{"id" => id, "work_project" => work_project_params}) do
    work_project = WorkProjects.get_work_project!(id)

    case WorkProjects.update_work_project(work_project, work_project_params) do
      {:ok, work_project} ->
        conn
        |> put_flash(:info, "Work project updated successfully.")
        |> redirect(to: Routes.work_project_path(conn, :show, work_project))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", work_project: work_project, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    work_project = WorkProjects.get_work_project!(id)
    {:ok, _work_project} = WorkProjects.delete_work_project(work_project)

    conn
    |> put_flash(:info, "Work project deleted successfully.")
    |> redirect(to: Routes.work_project_path(conn, :index))
  end
end
