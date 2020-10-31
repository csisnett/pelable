defmodule PelableWeb.TaskController do
  use PelableWeb, :controller

  alias Pelable.Learn
  alias Pelable.Learn.Task

  def index(conn, _params) do
    conn = assign(conn, :page_title, "My Tasks - Pelable")
    user = conn.assigns.current_user
    tasks = Learn.list_user_tasks(user)
    task_changeset = Learn.change_task(%Task{})
    render(conn, "index.html", tasks: tasks, task_changeset: task_changeset)
  end

  def new(conn, _params) do
    changeset = Learn.change_task(%Task{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"task" => task_params}) do
    user = conn.assigns.current_user
    case Learn.create_task(task_params, user) do
      {:ok, task} ->
        conn
        |> put_flash(:info, "Task created successfully.")
        |> redirect(to: Routes.task_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"uuid" => uuid}) do
    task = Learn.get_task_by_uuid(uuid)
    render(conn, "show.html", task: task)
  end

  def edit(conn, %{"uuid" => uuid}) do
    task = Learn.get_task_by_uuid(uuid)
    changeset = Learn.change_task(task)
    render(conn, "edit.html", task: task, changeset: changeset)
  end

  def update(conn, %{"uuid" => uuid, "task" => task_params}) do
    task = Learn.get_task_by_uuid(uuid)

    case Learn.update_task(task, task_params) do
      {:ok, task} ->
        conn
        |> put_flash(:info, "Task updated successfully.")
        |> redirect(to: Routes.task_path(conn, :show, task.slug, task.uuid))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", task: task, changeset: changeset)
    end
  end

  def delete(conn, %{"uuid" => uuid}) do
    task = Learn.get_task_by_uuid(uuid)
    {:ok, _task} = Learn.delete_task(task)

    conn
    |> put_flash(:info, "Task deleted successfully.")
    |> redirect(to: Routes.task_path(conn, :index))
  end
end
