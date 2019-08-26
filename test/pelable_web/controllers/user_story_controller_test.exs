defmodule PelableWeb.UserStoryControllerTest do
  use PelableWeb.ConnCase

  alias Pelable.WorkProjects

  @create_attrs %{body: "some body"}
  @update_attrs %{body: "some updated body"}
  @invalid_attrs %{body: nil}

  def fixture(:user_story) do
    {:ok, user_story} = WorkProjects.create_user_story(@create_attrs)
    user_story
  end

  describe "index" do
    test "lists all user_stories", %{conn: conn} do
      conn = get(conn, Routes.user_story_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing User stories"
    end
  end

  describe "new user_story" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.user_story_path(conn, :new))
      assert html_response(conn, 200) =~ "New User story"
    end
  end

  describe "create user_story" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.user_story_path(conn, :create), user_story: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.user_story_path(conn, :show, id)

      conn = get(conn, Routes.user_story_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show User story"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.user_story_path(conn, :create), user_story: @invalid_attrs)
      assert html_response(conn, 200) =~ "New User story"
    end
  end

  describe "edit user_story" do
    setup [:create_user_story]

    test "renders form for editing chosen user_story", %{conn: conn, user_story: user_story} do
      conn = get(conn, Routes.user_story_path(conn, :edit, user_story))
      assert html_response(conn, 200) =~ "Edit User story"
    end
  end

  describe "update user_story" do
    setup [:create_user_story]

    test "redirects when data is valid", %{conn: conn, user_story: user_story} do
      conn = put(conn, Routes.user_story_path(conn, :update, user_story), user_story: @update_attrs)
      assert redirected_to(conn) == Routes.user_story_path(conn, :show, user_story)

      conn = get(conn, Routes.user_story_path(conn, :show, user_story))
      assert html_response(conn, 200) =~ "some updated body"
    end

    test "renders errors when data is invalid", %{conn: conn, user_story: user_story} do
      conn = put(conn, Routes.user_story_path(conn, :update, user_story), user_story: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit User story"
    end
  end

  describe "delete user_story" do
    setup [:create_user_story]

    test "deletes chosen user_story", %{conn: conn, user_story: user_story} do
      conn = delete(conn, Routes.user_story_path(conn, :delete, user_story))
      assert redirected_to(conn) == Routes.user_story_path(conn, :index)
      assert_error_sent 404, fn ->
        get(conn, Routes.user_story_path(conn, :show, user_story))
      end
    end
  end

  defp create_user_story(_) do
    user_story = fixture(:user_story)
    {:ok, user_story: user_story}
  end
end
