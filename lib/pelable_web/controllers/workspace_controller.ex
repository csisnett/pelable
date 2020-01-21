defmodule PelableWeb.WorkspaceController do
  use PelableWeb, :controller

  alias Pelable.Learn
  alias Pelable.Learn.Workspace

  def index(conn, _params) do
    workspaces = Learn.list_workspaces()
    render(conn, "index.html", workspaces: workspaces)
  end

  def new(conn, _params) do
    changeset = Learn.change_workspace(%Workspace{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"workspace" => workspace_params}) do
    case Learn.create_workspace(workspace_params) do
      {:ok, workspace} ->
        conn
        |> put_flash(:info, "Workspace created successfully.")
        |> redirect(to: Routes.workspace_path(conn, :show, workspace))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    workspace = Learn.get_workspace!(id)
    render(conn, "show.html", workspace: workspace)
  end

  def edit(conn, %{"id" => id}) do
    workspace = Learn.get_workspace!(id)
    changeset = Learn.change_workspace(workspace)
    render(conn, "edit.html", workspace: workspace, changeset: changeset)
  end

  def update(conn, %{"id" => id, "workspace" => workspace_params}) do
    workspace = Learn.get_workspace!(id)

    case Learn.update_workspace(workspace, workspace_params) do
      {:ok, workspace} ->
        conn
        |> put_flash(:info, "Workspace updated successfully.")
        |> redirect(to: Routes.workspace_path(conn, :show, workspace))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", workspace: workspace, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    workspace = Learn.get_workspace!(id)
    {:ok, _workspace} = Learn.delete_workspace(workspace)

    conn
    |> put_flash(:info, "Workspace deleted successfully.")
    |> redirect(to: Routes.workspace_path(conn, :index))
  end
end
