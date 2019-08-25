defmodule PelableWeb.UserStoryController do
  use PelableWeb, :controller

  alias Pelable.WorkProject
  alias Pelable.WorkProject.UserStory

  def index(conn, _params) do
    user_stories = WorkProject.list_user_stories()
    render(conn, "index.html", user_stories: user_stories)
  end

  def new(conn, _params) do
    changeset = WorkProject.change_user_story(%UserStory{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user_story" => user_story_params}) do
    case WorkProject.create_user_story(user_story_params) do
      {:ok, user_story} ->
        conn
        |> put_flash(:info, "User story created successfully.")
        |> redirect(to: Routes.user_story_path(conn, :show, user_story))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    user_story = WorkProject.get_user_story!(id)
    render(conn, "show.html", user_story: user_story)
  end

  def edit(conn, %{"id" => id}) do
    user_story = WorkProject.get_user_story!(id)
    changeset = WorkProject.change_user_story(user_story)
    render(conn, "edit.html", user_story: user_story, changeset: changeset)
  end

  def update(conn, %{"id" => id, "user_story" => user_story_params}) do
    user_story = WorkProject.get_user_story!(id)

    case WorkProject.update_user_story(user_story, user_story_params) do
      {:ok, user_story} ->
        conn
        |> put_flash(:info, "User story updated successfully.")
        |> redirect(to: Routes.user_story_path(conn, :show, user_story))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", user_story: user_story, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    user_story = WorkProject.get_user_story!(id)
    {:ok, _user_story} = WorkProject.delete_user_story(user_story)

    conn
    |> put_flash(:info, "User story deleted successfully.")
    |> redirect(to: Routes.user_story_path(conn, :index))
  end
end
