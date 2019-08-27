defmodule PelableWeb.WorkProjectUserStoryControllerTest do
  use PelableWeb.ConnCase

  alias Pelable.WorkProjects

  @create_attrs %{status: "some status"}
  @update_attrs %{status: "some updated status"}
  @invalid_attrs %{status: nil}

  def fixture(:work_project_user_story) do
    {:ok, work_project_user_story} = WorkProjects.create_work_project_user_story(@create_attrs)
    work_project_user_story
  end

  describe "index" do
    test "lists all work_project_user_story", %{conn: conn} do
      conn = get(conn, Routes.work_project_user_story_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Work project user story"
    end
  end

  describe "new work_project_user_story" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.work_project_user_story_path(conn, :new))
      assert html_response(conn, 200) =~ "New Work project user story"
    end
  end

  describe "create work_project_user_story" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.work_project_user_story_path(conn, :create), work_project_user_story: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.work_project_user_story_path(conn, :show, id)

      conn = get(conn, Routes.work_project_user_story_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Work project user story"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.work_project_user_story_path(conn, :create), work_project_user_story: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Work project user story"
    end
  end

  describe "edit work_project_user_story" do
    setup [:create_work_project_user_story]

    test "renders form for editing chosen work_project_user_story", %{conn: conn, work_project_user_story: work_project_user_story} do
      conn = get(conn, Routes.work_project_user_story_path(conn, :edit, work_project_user_story))
      assert html_response(conn, 200) =~ "Edit Work project user story"
    end
  end

  describe "update work_project_user_story" do
    setup [:create_work_project_user_story]

    test "redirects when data is valid", %{conn: conn, work_project_user_story: work_project_user_story} do
      conn = put(conn, Routes.work_project_user_story_path(conn, :update, work_project_user_story), work_project_user_story: @update_attrs)
      assert redirected_to(conn) == Routes.work_project_user_story_path(conn, :show, work_project_user_story)

      conn = get(conn, Routes.work_project_user_story_path(conn, :show, work_project_user_story))
      assert html_response(conn, 200) =~ "some updated status"
    end

    test "renders errors when data is invalid", %{conn: conn, work_project_user_story: work_project_user_story} do
      conn = put(conn, Routes.work_project_user_story_path(conn, :update, work_project_user_story), work_project_user_story: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Work project user story"
    end
  end

  describe "delete work_project_user_story" do
    setup [:create_work_project_user_story]

    test "deletes chosen work_project_user_story", %{conn: conn, work_project_user_story: work_project_user_story} do
      conn = delete(conn, Routes.work_project_user_story_path(conn, :delete, work_project_user_story))
      assert redirected_to(conn) == Routes.work_project_user_story_path(conn, :index)
      assert_error_sent 404, fn ->
        get(conn, Routes.work_project_user_story_path(conn, :show, work_project_user_story))
      end
    end
  end

  defp create_work_project_user_story(_) do
    work_project_user_story = fixture(:work_project_user_story)
    {:ok, work_project_user_story: work_project_user_story}
  end
end
