defmodule PelableWeb.ProjectUserStoryControllerTest do
  use PelableWeb.ConnCase

  alias Pelable.WorkProjects

  @create_attrs %{status: "some status"}
  @update_attrs %{status: "some updated status"}
  @invalid_attrs %{status: nil}

  def fixture(:project_user_story) do
    {:ok, project_user_story} = WorkProjects.create_project_user_story(@create_attrs)
    project_user_story
  end

  describe "index" do
    test "lists all work_project_user_story", %{conn: conn} do
      conn = get(conn, Routes.project_user_story_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Workproject userstory"
    end
  end

  describe "new project_user_story" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.project_user_story_path(conn, :new))
      assert html_response(conn, 200) =~ "New Project user story"
    end
  end

  describe "create project_user_story" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.project_user_story_path(conn, :create), project_user_story: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.project_user_story_path(conn, :show, id)

      conn = get(conn, Routes.project_user_story_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Project user story"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.project_user_story_path(conn, :create), project_user_story: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Project user story"
    end
  end

  describe "edit project_user_story" do
    setup [:create_project_user_story]

    test "renders form for editing chosen project_user_story", %{conn: conn, project_user_story: project_user_story} do
      conn = get(conn, Routes.project_user_story_path(conn, :edit, project_user_story))
      assert html_response(conn, 200) =~ "Edit Project user story"
    end
  end

  describe "update project_user_story" do
    setup [:create_project_user_story]

    test "redirects when data is valid", %{conn: conn, project_user_story: project_user_story} do
      conn = put(conn, Routes.project_user_story_path(conn, :update, project_user_story), project_user_story: @update_attrs)
      assert redirected_to(conn) == Routes.project_user_story_path(conn, :show, project_user_story)

      conn = get(conn, Routes.project_user_story_path(conn, :show, project_user_story))
      assert html_response(conn, 200) =~ "some updated status"
    end

    test "renders errors when data is invalid", %{conn: conn, project_user_story: project_user_story} do
      conn = put(conn, Routes.project_user_story_path(conn, :update, project_user_story), project_user_story: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Project user story"
    end
  end

  describe "delete project_user_story" do
    setup [:create_project_user_story]

    test "deletes chosen project_user_story", %{conn: conn, project_user_story: project_user_story} do
      conn = delete(conn, Routes.project_user_story_path(conn, :delete, project_user_story))
      assert redirected_to(conn) == Routes.project_user_story_path(conn, :index)
      assert_error_sent 404, fn ->
        get(conn, Routes.project_user_story_path(conn, :show, project_user_story))
      end
    end
  end

  defp create_project_user_story(_) do
    project_user_story = fixture(:project_user_story)
    {:ok, project_user_story: project_user_story}
  end
end
