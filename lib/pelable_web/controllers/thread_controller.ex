defmodule PelableWeb.ThreadController do
  use PelableWeb, :controller

  alias Pelable.Learn
  alias Pelable.Learn.Thread

  def index(conn, _params) do
    threads = Learn.list_threads()
    render(conn, "index.html", threads: threads)
  end

  def new(conn, _params) do
    changeset = Learn.change_thread(%Thread{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"thread" => thread_params}) do
    case Learn.create_thread(thread_params) do
      {:ok, thread} ->
        conn
        |> put_flash(:info, "Thread created successfully.")
        |> redirect(to: Routes.thread_path(conn, :show, thread))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    thread = Learn.get_thread!(id)
    render(conn, "show.html", thread: thread)
  end

  def edit(conn, %{"id" => id}) do
    thread = Learn.get_thread!(id)
    changeset = Learn.change_thread(thread)
    render(conn, "edit.html", thread: thread, changeset: changeset)
  end

  def update(conn, %{"id" => id, "thread" => thread_params}) do
    thread = Learn.get_thread!(id)

    case Learn.update_thread(thread, thread_params) do
      {:ok, thread} ->
        conn
        |> put_flash(:info, "Thread updated successfully.")
        |> redirect(to: Routes.thread_path(conn, :show, thread))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", thread: thread, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    thread = Learn.get_thread!(id)
    {:ok, _thread} = Learn.delete_thread(thread)

    conn
    |> put_flash(:info, "Thread deleted successfully.")
    |> redirect(to: Routes.thread_path(conn, :index))
  end
end
