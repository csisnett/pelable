defmodule PelableWeb.HabitCompletionRewardControllerTest do
  use PelableWeb.ConnCase

  alias Pelable.Habits
  alias Pelable.Habits.HabitCompletionReward

  @create_attrs %{
    taken?: true,
    uuid: "7488a646-e31f-11e4-aace-600308960662"
  }
  @update_attrs %{
    taken?: false,
    uuid: "7488a646-e31f-11e4-aace-600308960668"
  }
  @invalid_attrs %{taken?: nil, uuid: nil}

  def fixture(:habit_completion_reward) do
    {:ok, habit_completion_reward} = Habits.create_habit_completion_reward(@create_attrs)
    habit_completion_reward
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all habitcompletionreward", %{conn: conn} do
      conn = get(conn, Routes.habit_completion_reward_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create habit_completion_reward" do
    test "renders habit_completion_reward when data is valid", %{conn: conn} do
      conn = post(conn, Routes.habit_completion_reward_path(conn, :create), habit_completion_reward: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.habit_completion_reward_path(conn, :show, id))

      assert %{
               "id" => id,
               "taken?" => true,
               "uuid" => "7488a646-e31f-11e4-aace-600308960662"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.habit_completion_reward_path(conn, :create), habit_completion_reward: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update habit_completion_reward" do
    setup [:create_habit_completion_reward]

    test "renders habit_completion_reward when data is valid", %{conn: conn, habit_completion_reward: %HabitCompletionReward{id: id} = habit_completion_reward} do
      conn = put(conn, Routes.habit_completion_reward_path(conn, :update, habit_completion_reward), habit_completion_reward: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.habit_completion_reward_path(conn, :show, id))

      assert %{
               "id" => id,
               "taken?" => false,
               "uuid" => "7488a646-e31f-11e4-aace-600308960668"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, habit_completion_reward: habit_completion_reward} do
      conn = put(conn, Routes.habit_completion_reward_path(conn, :update, habit_completion_reward), habit_completion_reward: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete habit_completion_reward" do
    setup [:create_habit_completion_reward]

    test "deletes chosen habit_completion_reward", %{conn: conn, habit_completion_reward: habit_completion_reward} do
      conn = delete(conn, Routes.habit_completion_reward_path(conn, :delete, habit_completion_reward))
      assert response(conn, 204)

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
