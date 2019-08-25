defmodule PelableWeb.WorkProjectControllerTest do
  use PelableWeb.ConnCase

  alias Pelable.WorkProjects

  @create_attrs %{description: "some description", end_date: "2010-04-17T14:00:00Z", public_status: "some public_status", repo_url: "some repo_url", start_date: "2010-04-17T14:00:00Z", work_status: "some work_status"}
  @update_attrs %{description: "some updated description", end_date: "2011-05-18T15:01:01Z", public_status: "some updated public_status", repo_url: "some updated repo_url", start_date: "2011-05-18T15:01:01Z", work_status: "some updated work_status"}
  @invalid_attrs %{description: nil, end_date: nil, public_status: nil, repo_url: nil, start_date: nil, work_status: nil}

  def fixture(:work_project) do
    {:ok, work_project} = WorkProjects.create_work_project(@create_attrs)
    work_project
  end

  describe "index" do
    test "lists all work_projects", %{conn: conn} do
      conn = get(conn, Routes.work_project_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Work projects"
    end
  end

  describe "new work_project" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.work_project_path(conn, :new))
      assert html_response(conn, 200) =~ "New Work project"
    end
  end

  describe "create work_project" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.work_project_path(conn, :create), work_project: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.work_project_path(conn, :show, id)

      conn = get(conn, Routes.work_project_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Work project"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.work_project_path(conn, :create), work_project: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Work project"
    end
  end

  describe "edit work_project" do
    setup [:create_work_project]

    test "renders form for editing chosen work_project", %{conn: conn, work_project: work_project} do
      conn = get(conn, Routes.work_project_path(conn, :edit, work_project))
      assert html_response(conn, 200) =~ "Edit Work project"
    end
  end

  describe "update work_project" do
    setup [:create_work_project]

    test "redirects when data is valid", %{conn: conn, work_project: work_project} do
      conn = put(conn, Routes.work_project_path(conn, :update, work_project), work_project: @update_attrs)
      assert redirected_to(conn) == Routes.work_project_path(conn, :show, work_project)

      conn = get(conn, Routes.work_project_path(conn, :show, work_project))
      assert html_response(conn, 200) =~ "some updated description"
    end

    test "renders errors when data is invalid", %{conn: conn, work_project: work_project} do
      conn = put(conn, Routes.work_project_path(conn, :update, work_project), work_project: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Work project"
    end
  end

  describe "delete work_project" do
    setup [:create_work_project]

    test "deletes chosen work_project", %{conn: conn, work_project: work_project} do
      conn = delete(conn, Routes.work_project_path(conn, :delete, work_project))
      assert redirected_to(conn) == Routes.work_project_path(conn, :index)
      assert_error_sent 404, fn ->
        get(conn, Routes.work_project_path(conn, :show, work_project))
      end
    end
  end

  defp create_work_project(_) do
    work_project = fixture(:work_project)
    {:ok, work_project: work_project}
  end
end
