defmodule PelableWeb.ProjectUserStoryController do
  use PelableWeb, :controller

  alias Pelable.WorkProjects
  alias Pelable.WorkProjects.ProjectUserStory

  def index(conn, _params) do
    workproject_userstory = WorkProjects.list_workproject_userstory()
    render(conn, "index.html", workproject_userstory: workproject_userstory)
  end

  def new(conn, _params) do
    changeset = WorkProjects.change_project_user_story(%ProjectUserStory{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"project_user_story" => project_user_story_params}) do
    case WorkProjects.create_project_user_story(project_user_story_params) do
      {:ok, project_user_story} ->
        conn
        |> put_flash(:info, "Project user story created successfully.")
        |> redirect(to: Routes.project_user_story_path(conn, :show, project_user_story))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    project_user_story = WorkProjects.get_project_user_story!(id)
    render(conn, "show.html", project_user_story: project_user_story)
  end

  def edit(conn, %{"id" => id}) do
    project_user_story = WorkProjects.get_project_user_story!(id)
    changeset = WorkProjects.change_project_user_story(project_user_story)
    render(conn, "edit.html", project_user_story: project_user_story, changeset: changeset)
  end

  def update(conn, %{"id" => id, "project_user_story" => project_user_story_params}) do
    project_user_story = WorkProjects.get_project_user_story!(id)

    case WorkProjects.update_project_user_story(project_user_story, project_user_story_params) do
      {:ok, project_user_story} ->
        conn
        |> put_flash(:info, "Project user story updated successfully.")
        |> redirect(to: Routes.project_user_story_path(conn, :show, project_user_story))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", project_user_story: project_user_story, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    project_user_story = WorkProjects.get_project_user_story!(id)
    {:ok, _project_user_story} = WorkProjects.delete_project_user_story(project_user_story)

    conn
    |> put_flash(:info, "Project user story deleted successfully.")
    |> redirect(to: Routes.project_user_story_path(conn, :index))
  end
end
