defmodule PelableWeb.RewardControllerTest do
  use PelableWeb.ConnCase

  alias Pelable.Habits

  @create_attrs %{description: "some description", name: "some name", uuid: "7488a646-e31f-11e4-aace-600308960662"}
  @update_attrs %{description: "some updated description", name: "some updated name", uuid: "7488a646-e31f-11e4-aace-600308960668"}
  @invalid_attrs %{description: nil, name: nil, uuid: nil}

  def fixture(:reward) do
    {:ok, reward} = Habits.create_reward(@create_attrs)
    reward
  end

  describe "index" do
    test "lists all rewards", %{conn: conn} do
      conn = get(conn, Routes.reward_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Rewards"
    end
  end

  describe "new reward" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.reward_path(conn, :new))
      assert html_response(conn, 200) =~ "New Reward"
    end
  end

  describe "create reward" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.reward_path(conn, :create), reward: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.reward_path(conn, :show, id)

      conn = get(conn, Routes.reward_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Reward"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.reward_path(conn, :create), reward: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Reward"
    end
  end

  describe "edit reward" do
    setup [:create_reward]

    test "renders form for editing chosen reward", %{conn: conn, reward: reward} do
      conn = get(conn, Routes.reward_path(conn, :edit, reward))
      assert html_response(conn, 200) =~ "Edit Reward"
    end
  end

  describe "update reward" do
    setup [:create_reward]

    test "redirects when data is valid", %{conn: conn, reward: reward} do
      conn = put(conn, Routes.reward_path(conn, :update, reward), reward: @update_attrs)
      assert redirected_to(conn) == Routes.reward_path(conn, :show, reward)

      conn = get(conn, Routes.reward_path(conn, :show, reward))
      assert html_response(conn, 200) =~ "some updated description"
    end

    test "renders errors when data is invalid", %{conn: conn, reward: reward} do
      conn = put(conn, Routes.reward_path(conn, :update, reward), reward: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Reward"
    end
  end

  describe "delete reward" do
    setup [:create_reward]

    test "deletes chosen reward", %{conn: conn, reward: reward} do
      conn = delete(conn, Routes.reward_path(conn, :delete, reward))
      assert redirected_to(conn) == Routes.reward_path(conn, :index)
      assert_error_sent 404, fn ->
        get(conn, Routes.reward_path(conn, :show, reward))
      end
    end
  end

  defp create_reward(_) do
    reward = fixture(:reward)
    %{reward: reward}
  end
end
