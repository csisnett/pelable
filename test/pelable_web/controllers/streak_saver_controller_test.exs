defmodule PelableWeb.StreakSaverControllerTest do
  use PelableWeb.ConnCase

  alias Pelable.Habits
  alias Pelable.Habits.StreakSaver

  @create_attrs %{
    end_date: ~D[2010-04-17],
    start_date: ~D[2010-04-17]
  }
  @update_attrs %{
    end_date: ~D[2011-05-18],
    start_date: ~D[2011-05-18]
  }
  @invalid_attrs %{end_date: nil, start_date: nil}

  def fixture(:streak_saver) do
    {:ok, streak_saver} = Habits.create_streak_saver(@create_attrs)
    streak_saver
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all streak_saver", %{conn: conn} do
      conn = get(conn, Routes.streak_saver_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create streak_saver" do
    test "renders streak_saver when data is valid", %{conn: conn} do
      conn = post(conn, Routes.streak_saver_path(conn, :create), streak_saver: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.streak_saver_path(conn, :show, id))

      assert %{
               "id" => id,
               "end_date" => "2010-04-17",
               "start_date" => "2010-04-17"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.streak_saver_path(conn, :create), streak_saver: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update streak_saver" do
    setup [:create_streak_saver]

    test "renders streak_saver when data is valid", %{conn: conn, streak_saver: %StreakSaver{id: id} = streak_saver} do
      conn = put(conn, Routes.streak_saver_path(conn, :update, streak_saver), streak_saver: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.streak_saver_path(conn, :show, id))

      assert %{
               "id" => id,
               "end_date" => "2011-05-18",
               "start_date" => "2011-05-18"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, streak_saver: streak_saver} do
      conn = put(conn, Routes.streak_saver_path(conn, :update, streak_saver), streak_saver: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete streak_saver" do
    setup [:create_streak_saver]

    test "deletes chosen streak_saver", %{conn: conn, streak_saver: streak_saver} do
      conn = delete(conn, Routes.streak_saver_path(conn, :delete, streak_saver))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.streak_saver_path(conn, :show, streak_saver))
      end
    end
  end

  defp create_streak_saver(_) do
    streak_saver = fixture(:streak_saver)
    %{streak_saver: streak_saver}
  end
end
