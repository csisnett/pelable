defmodule PelableWeb.ProjectVersionControllerTest do
  use PelableWeb.ConnCase

  alias Pelable.WorkProject

  @create_attrs %{description: "some description", name: "some name", public_status: "some public_status"}
  @update_attrs %{description: "some updated description", name: "some updated name", public_status: "some updated public_status"}
  @invalid_attrs %{description: nil, name: nil, public_status: nil}

  def fixture(:project_version) do
    {:ok, project_version} = WorkProject.create_project_version(@create_attrs)
    project_version
  end

  describe "index" do
    test "lists all project_versions", %{conn: conn} do
      conn = get(conn, Routes.project_version_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Project versions"
    end
  end

  describe "new project_version" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.project_version_path(conn, :new))
      assert html_response(conn, 200) =~ "New Project version"
    end
  end

  describe "create project_version" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.project_version_path(conn, :create), project_version: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.project_version_path(conn, :show, id)

      conn = get(conn, Routes.project_version_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Project version"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.project_version_path(conn, :create), project_version: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Project version"
    end
  end

  describe "edit project_version" do
    setup [:create_project_version]

    test "renders form for editing chosen project_version", %{conn: conn, project_version: project_version} do
      conn = get(conn, Routes.project_version_path(conn, :edit, project_version))
      assert html_response(conn, 200) =~ "Edit Project version"
    end
  end

  describe "update project_version" do
    setup [:create_project_version]

    test "redirects when data is valid", %{conn: conn, project_version: project_version} do
      conn = put(conn, Routes.project_version_path(conn, :update, project_version), project_version: @update_attrs)
      assert redirected_to(conn) == Routes.project_version_path(conn, :show, project_version)

      conn = get(conn, Routes.project_version_path(conn, :show, project_version))
      assert html_response(conn, 200) =~ "some updated description"
    end

    test "renders errors when data is invalid", %{conn: conn, project_version: project_version} do
      conn = put(conn, Routes.project_version_path(conn, :update, project_version), project_version: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Project version"
    end
  end

  describe "delete project_version" do
    setup [:create_project_version]

    test "deletes chosen project_version", %{conn: conn, project_version: project_version} do
      conn = delete(conn, Routes.project_version_path(conn, :delete, project_version))
      assert redirected_to(conn) == Routes.project_version_path(conn, :index)
      assert_error_sent 404, fn ->
        get(conn, Routes.project_version_path(conn, :show, project_version))
      end
    end
  end

  defp create_project_version(_) do
    project_version = fixture(:project_version)
    {:ok, project_version: project_version}
  end
end
