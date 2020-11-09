defmodule PelableWeb.BookmarkController do
  use PelableWeb, :controller

  alias Pelable.Learn
  alias Pelable.Learn.Bookmark

  def index(conn, _params) do
    bookmarks = Learn.list_bookmarks()
    render(conn, "index.html", bookmarks: bookmarks)
  end

  def new(conn, _params) do
    changeset = Learn.change_bookmark(%Bookmark{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"bookmark" => bookmark_params}) do
    user = conn.assigns.current_user
    case Learn.create_bookmark(bookmark_params, user) do
      {:ok, bookmark} ->
        conn
        |> put_flash(:info, "Bookmark created successfully.")
        |> redirect(to: Routes.bookmark_path(conn, :show, bookmark.uuid))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"uuid" => uuid}) do
    bookmark = Learn.get_bookmark_by_uuid(uuid)
    render(conn, "show.html", bookmark: bookmark)
  end

  def edit(conn, %{"uuid" => uuid}) do
    bookmark = Learn.get_bookmark_by_uuid(uuid)
    changeset = Learn.change_bookmark(bookmark)
    render(conn, "edit.html", bookmark: bookmark, changeset: changeset)
  end

  def update(conn, %{"uuid" => uuid, "bookmark" => bookmark_params}) do
    bookmark = Learn.get_bookmark_by_uuid(uuid)
    user = conn.assigns.current_user
    case Learn.update_bookmark(bookmark, bookmark_params, user) do
      {:ok, bookmark} ->
        conn
        |> put_flash(:info, "Bookmark updated successfully.")
        |> redirect(to: Routes.bookmark_path(conn, :show, bookmark.uuid))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", bookmark: bookmark, changeset: changeset)
    end
  end

  def delete(conn, %{"uuid" => uuid}) do
    bookmark = Learn.get_bookmark_by_uuid(uuid)
    {:ok, _bookmark} = Learn.delete_bookmark(bookmark)

    conn
    |> put_flash(:info, "Bookmark deleted successfully.")
    |> redirect(to: Routes.bookmark_path(conn, :index))
  end
end
