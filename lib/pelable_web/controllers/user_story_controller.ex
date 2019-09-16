defmodule PelableWeb.UserStoryController do
  use PelableWeb, :controller

  alias Pelable.WorkProjects
  alias Pelable.WorkProjects.UserStory

  def index(conn, _params) do
    user_stories = WorkProjects.list_user_stories()
    render(conn, "index.html", user_stories: user_stories)
  end

  def new(conn, %{"slug" => slug, "uuid" => uuid} = params) do
    user_story = %UserStory{}
    changeset = WorkProjects.change_user_story(user_story)
    resp = %{"changeset" => changeset, "params" => params}
    render(conn, "new.html", changeset: changeset, resp: resp)
  end

  def create(conn, %{"slug" => slug, "uuid" => uuid, "user_story" => user_story_params}) do
    work_project = WorkProjects.get_work_project_uuid(uuid)
    case WorkProjects.create_user_story_for_work_project(user_story_params, work_project) do
      {:ok, user_story} ->
        conn
        |> put_flash(:info, "User story created successfully.")
        |> redirect(to: Routes.work_project_path(conn, :show, work_project.slug, work_project.uuid))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"slug" => slug, "uuid" => uuid}) do
    conn
    |> redirect(to: Routes.work_project_path(conn, :show, slug, uuid))
  end

  def edit(conn, %{"id" => id}) do
    user_story = WorkProjects.get_user_story!(id)
    changeset = WorkProjects.change_user_story(user_story)
    render(conn, "edit.html", user_story: user_story, changeset: changeset)
  end

  def update(conn, %{"id" => id, "user_story" => user_story_params}) do
    user_story = WorkProjects.get_user_story!(id)

    case WorkProjects.update_user_story(user_story, user_story_params) do
      {:ok, user_story} ->
        conn
        |> put_flash(:info, "User story updated successfully.")
        |> redirect(to: Routes.user_story_path(conn, :show, user_story))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", user_story: user_story, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    user_story = WorkProjects.get_user_story!(id)
    {:ok, _user_story} = WorkProjects.delete_user_story(user_story)

    conn
    |> put_flash(:info, "User story deleted successfully.")
    |> redirect(to: Routes.user_story_path(conn, :index))
  end
end
