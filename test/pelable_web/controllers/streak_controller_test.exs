defmodule PelableWeb.StreakControllerTest do
  use PelableWeb.ConnCase

  alias Pelable.Habits

  @create_attrs %{habit: "some habit"}
  @update_attrs %{habit: "some updated habit"}
  @invalid_attrs %{habit: nil}

  def fixture(:streak) do
    {:ok, streak} = Habits.create_streak(@create_attrs)
    streak
  end

  describe "index" do
    test "lists all streaks", %{conn: conn} do
      conn = get(conn, Routes.streak_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Streaks"
    end
  end

  describe "new streak" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.streak_path(conn, :new))
      assert html_response(conn, 200) =~ "New Streak"
    end
  end

  describe "create streak" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.streak_path(conn, :create), streak: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.streak_path(conn, :show, id)

      conn = get(conn, Routes.streak_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Streak"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.streak_path(conn, :create), streak: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Streak"
    end
  end

  describe "edit streak" do
    setup [:create_streak]

    test "renders form for editing chosen streak", %{conn: conn, streak: streak} do
      conn = get(conn, Routes.streak_path(conn, :edit, streak))
      assert html_response(conn, 200) =~ "Edit Streak"
    end
  end

  describe "update streak" do
    setup [:create_streak]

    test "redirects when data is valid", %{conn: conn, streak: streak} do
      conn = put(conn, Routes.streak_path(conn, :update, streak), streak: @update_attrs)
      assert redirected_to(conn) == Routes.streak_path(conn, :show, streak)

      conn = get(conn, Routes.streak_path(conn, :show, streak))
      assert html_response(conn, 200) =~ "some updated habit"
    end

    test "renders errors when data is invalid", %{conn: conn, streak: streak} do
      conn = put(conn, Routes.streak_path(conn, :update, streak), streak: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Streak"
    end
  end

  describe "delete streak" do
    setup [:create_streak]

    test "deletes chosen streak", %{conn: conn, streak: streak} do
      conn = delete(conn, Routes.streak_path(conn, :delete, streak))
      assert redirected_to(conn) == Routes.streak_path(conn, :index)
      assert_error_sent 404, fn ->
        get(conn, Routes.streak_path(conn, :show, streak))
      end
    end
  end

  defp create_streak(_) do
    streak = fixture(:streak)
    %{streak: streak}
  end
end
