defmodule PelableWeb.PostController do
  use PelableWeb, :controller

  alias Pelable.Learn
  alias Pelable.Learn.Post

  def index(conn, _params) do
    posts = Learn.list_posts()
    render(conn, "index.html", posts: posts)
  end

  def new(conn, _params) do
    changeset = Learn.change_post(%Post{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"post" => post_params}) do
    user = conn.assigns.current_user
    post_params = Map.put(post_params, "creator_id", user.id)
    case Learn.create_post(post_params, user) do
      {:ok, post} ->
        conn
        |> put_flash(:info, "Post created successfully.")
        |> redirect(to: Routes.post_path(conn, :show, post.title || "Untitled", post.uuid))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"uuid" => uuid}) do
    post = Learn.get_post_by_uuid(uuid)
    render(conn, "show.html", post: post)
  end

  def edit(conn, %{"uuid" => uuid}) do
    post = Learn.get_post_by_uuid(uuid)
    changeset = Learn.change_post(post)
    render(conn, "edit.html", post: post, changeset: changeset)
  end

  def update(conn, %{"uuid" => uuid, "post" => post_params}) do
    user = conn.assigns.current_user
    post = Learn.get_post_by_uuid(uuid)

    case Learn.update_post(post, user, post_params) do
      {:ok, post} ->
        conn
        |> put_flash(:info, "Post updated successfully.")
        |> redirect(to: Routes.post_path(conn, :show, post.title || "Untitled", post.uuid))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", post: post, changeset: changeset)
    end
  end

  def delete(conn, %{"uuid" => uuid}) do
    post = Learn.get_post_by_uuid(uuid)
    user = conn.assigns.current_user
    {:ok, _post} = Learn.delete_post(post, user)

    conn
    |> put_flash(:info, "Post deleted successfully.")
    |> redirect(to: Routes.post_path(conn, :index))
  end
end
