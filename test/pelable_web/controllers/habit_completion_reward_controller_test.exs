defmodule PelableWeb.HabitCompletionRewardControllerTest do
  use PelableWeb.ConnCase

  alias Pelable.Habits

  @create_attrs %{}
  @update_attrs %{}
  @invalid_attrs %{}

  def fixture(:habit_completion_reward) do
    {:ok, habit_completion_reward} = Habits.create_habit_completion_reward(@create_attrs)
    habit_completion_reward
  end

  describe "index" do
    test "lists all habit_completion_reward", %{conn: conn} do
      conn = get(conn, Routes.habit_completion_reward_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Habit completion reward"
    end
  end

  describe "new habit_completion_reward" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.habit_completion_reward_path(conn, :new))
      assert html_response(conn, 200) =~ "New Habit completion reward"
    end
  end

  describe "create habit_completion_reward" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.habit_completion_reward_path(conn, :create), habit_completion_reward: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.habit_completion_reward_path(conn, :show, id)

      conn = get(conn, Routes.habit_completion_reward_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Habit completion reward"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.habit_completion_reward_path(conn, :create), habit_completion_reward: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Habit completion reward"
    end
  end

  describe "edit habit_completion_reward" do
    setup [:create_habit_completion_reward]

    test "renders form for editing chosen habit_completion_reward", %{conn: conn, habit_completion_reward: habit_completion_reward} do
      conn = get(conn, Routes.habit_completion_reward_path(conn, :edit, habit_completion_reward))
      assert html_response(conn, 200) =~ "Edit Habit completion reward"
    end
  end

  describe "update habit_completion_reward" do
    setup [:create_habit_completion_reward]

    test "redirects when data is valid", %{conn: conn, habit_completion_reward: habit_completion_reward} do
      conn = put(conn, Routes.habit_completion_reward_path(conn, :update, habit_completion_reward), habit_completion_reward: @update_attrs)
      assert redirected_to(conn) == Routes.habit_completion_reward_path(conn, :show, habit_completion_reward)

      conn = get(conn, Routes.habit_completion_reward_path(conn, :show, habit_completion_reward))
      assert html_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn, habit_completion_reward: habit_completion_reward} do
      conn = put(conn, Routes.habit_completion_reward_path(conn, :update, habit_completion_reward), habit_completion_reward: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Habit completion reward"
    end
  end

  describe "delete habit_completion_reward" do
    setup [:create_habit_completion_reward]

    test "deletes chosen habit_completion_reward", %{conn: conn, habit_completion_reward: habit_completion_reward} do
      conn = delete(conn, Routes.habit_completion_reward_path(conn, :delete, habit_completion_reward))
      assert redirected_to(conn) == Routes.habit_completion_reward_path(conn, :index)
      assert_error_sent 404, fn ->
        get(conn, Routes.habit_completion_reward_path(conn, :show, habit_completion_reward))
      end
    end
  end

  defp create_habit_completion_reward(_) do
    habit_completion_reward = fixture(:habit_completion_reward)
    %{habit_completion_reward: habit_completion_reward}
  end
end
