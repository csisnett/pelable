defmodule PelableWeb.HabitCompletionControllerTest do
  use PelableWeb.ConnCase

  alias Pelable.Habits

  @create_attrs %{local_datetime: ~N[2010-04-17 14:00:00]}
  @update_attrs %{local_datetime: ~N[2011-05-18 15:01:01]}
  @invalid_attrs %{local_datetime: nil}

  def fixture(:habit_completion) do
    {:ok, habit_completion} = Habits.create_habit_completion(@create_attrs)
    habit_completion
  end

  describe "index" do
    test "lists all habitcompletion", %{conn: conn} do
      conn = get(conn, Routes.habit_completion_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Habitcompletion"
    end
  end

  describe "new habit_completion" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.habit_completion_path(conn, :new))
      assert html_response(conn, 200) =~ "New Habit completion"
    end
  end

  describe "create habit_completion" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.habit_completion_path(conn, :create), habit_completion: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.habit_completion_path(conn, :show, id)

      conn = get(conn, Routes.habit_completion_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Habit completion"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.habit_completion_path(conn, :create), habit_completion: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Habit completion"
    end
  end

  describe "edit habit_completion" do
    setup [:create_habit_completion]

    test "renders form for editing chosen habit_completion", %{conn: conn, habit_completion: habit_completion} do
      conn = get(conn, Routes.habit_completion_path(conn, :edit, habit_completion))
      assert html_response(conn, 200) =~ "Edit Habit completion"
    end
  end

  describe "update habit_completion" do
    setup [:create_habit_completion]

    test "redirects when data is valid", %{conn: conn, habit_completion: habit_completion} do
      conn = put(conn, Routes.habit_completion_path(conn, :update, habit_completion), habit_completion: @update_attrs)
      assert redirected_to(conn) == Routes.habit_completion_path(conn, :show, habit_completion)

      conn = get(conn, Routes.habit_completion_path(conn, :show, habit_completion))
      assert html_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn, habit_completion: habit_completion} do
      conn = put(conn, Routes.habit_completion_path(conn, :update, habit_completion), habit_completion: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Habit completion"
    end
  end

  describe "delete habit_completion" do
    setup [:create_habit_completion]

    test "deletes chosen habit_completion", %{conn: conn, habit_completion: habit_completion} do
      conn = delete(conn, Routes.habit_completion_path(conn, :delete, habit_completion))
      assert redirected_to(conn) == Routes.habit_completion_path(conn, :index)
      assert_error_sent 404, fn ->
        get(conn, Routes.habit_completion_path(conn, :show, habit_completion))
      end
    end
  end

  defp create_habit_completion(_) do
    habit_completion = fixture(:habit_completion)
    %{habit_completion: habit_completion}
  end
end
