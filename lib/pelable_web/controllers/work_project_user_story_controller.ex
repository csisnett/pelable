defmodule PelableWeb.WorkProjectUserStoryController do
  use PelableWeb, :controller

  alias Pelable.WorkProjects
  alias Pelable.WorkProjects.WorkProjectUserStory

  def index(conn, _params) do
    work_project_user_story = WorkProjects.list_work_project_user_story()
    render(conn, "index.html", work_project_user_story: work_project_user_story)
  end

  def new(conn, _params) do
    changeset = WorkProjects.change_work_project_user_story(%WorkProjectUserStory{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"work_project_user_story" => work_project_user_story_params}) do
    case WorkProjects.create_work_project_user_story(work_project_user_story_params) do
      {:ok, work_project_user_story} ->
        conn
        |> put_flash(:info, "Work project user story created successfully.")
        |> redirect(to: Routes.work_project_user_story_path(conn, :show, work_project_user_story))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    work_project_user_story = WorkProjects.get_work_project_user_story!(id)
    render(conn, "show.html", work_project_user_story: work_project_user_story)
  end

  def edit(conn, %{"id" => id}) do
    work_project_user_story = WorkProjects.get_work_project_user_story!(id)
    changeset = WorkProjects.change_work_project_user_story(work_project_user_story)
    render(conn, "edit.html", work_project_user_story: work_project_user_story, changeset: changeset)
  end

  def update(conn, %{"id" => id, "work_project_user_story" => work_project_user_story_params}) do
    work_project_user_story = WorkProjects.get_work_project_user_story!(id)

    case WorkProjects.update_work_project_user_story(work_project_user_story, work_project_user_story_params) do
      {:ok, work_project_user_story} ->
        conn
        |> put_flash(:info, "Work project user story updated successfully.")
        |> redirect(to: Routes.work_project_user_story_path(conn, :show, work_project_user_story))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", work_project_user_story: work_project_user_story, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    work_project_user_story = WorkProjects.get_work_project_user_story!(id)
    {:ok, _work_project_user_story} = WorkProjects.delete_work_project_user_story(work_project_user_story)

    conn
    |> put_flash(:info, "Work project user story deleted successfully.")
    |> redirect(to: Routes.work_project_user_story_path(conn, :index))
  end
end
