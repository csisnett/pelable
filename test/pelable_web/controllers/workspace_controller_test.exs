defmodule PelableWeb.WorkspaceControllerTest do
  use PelableWeb.ConnCase

  alias Pelable.Learn

  @create_attrs %{name: "some name", type: "some type"}
  @update_attrs %{name: "some updated name", type: "some updated type"}
  @invalid_attrs %{name: nil, type: nil}

  def fixture(:workspace) do
    {:ok, workspace} = Learn.create_workspace(@create_attrs)
    workspace
  end

  describe "index" do
    test "lists all workspaces", %{conn: conn} do
      conn = get(conn, Routes.workspace_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Workspaces"
    end
  end

  describe "new workspace" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.workspace_path(conn, :new))
      assert html_response(conn, 200) =~ "New Workspace"
    end
  end

  describe "create workspace" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.workspace_path(conn, :create), workspace: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.workspace_path(conn, :show, id)

      conn = get(conn, Routes.workspace_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Workspace"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.workspace_path(conn, :create), workspace: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Workspace"
    end
  end

  describe "edit workspace" do
    setup [:create_workspace]

    test "renders form for editing chosen workspace", %{conn: conn, workspace: workspace} do
      conn = get(conn, Routes.workspace_path(conn, :edit, workspace))
      assert html_response(conn, 200) =~ "Edit Workspace"
    end
  end

  describe "update workspace" do
    setup [:create_workspace]

    test "redirects when data is valid", %{conn: conn, workspace: workspace} do
      conn = put(conn, Routes.workspace_path(conn, :update, workspace), workspace: @update_attrs)
      assert redirected_to(conn) == Routes.workspace_path(conn, :show, workspace)

      conn = get(conn, Routes.workspace_path(conn, :show, workspace))
      assert html_response(conn, 200) =~ "some updated name"
    end

    test "renders errors when data is invalid", %{conn: conn, workspace: workspace} do
      conn = put(conn, Routes.workspace_path(conn, :update, workspace), workspace: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Workspace"
    end
  end

  describe "delete workspace" do
    setup [:create_workspace]

    test "deletes chosen workspace", %{conn: conn, workspace: workspace} do
      conn = delete(conn, Routes.workspace_path(conn, :delete, workspace))
      assert redirected_to(conn) == Routes.workspace_path(conn, :index)
      assert_error_sent 404, fn ->
        get(conn, Routes.workspace_path(conn, :show, workspace))
      end
    end
  end

  defp create_workspace(_) do
    workspace = fixture(:workspace)
    {:ok, workspace: workspace}
  end
end
