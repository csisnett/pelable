defmodule PelableWeb.TrackerControllerTest do
  use PelableWeb.ConnCase

  alias Pelable.Habits

  @create_attrs %{name: "some name"}
  @update_attrs %{name: "some updated name"}
  @invalid_attrs %{name: nil}

  def fixture(:tracker) do
    {:ok, tracker} = Habits.create_tracker(@create_attrs)
    tracker
  end

  describe "index" do
    test "lists all trackers", %{conn: conn} do
      conn = get(conn, Routes.tracker_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Trackers"
    end
  end

  describe "new tracker" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.tracker_path(conn, :new))
      assert html_response(conn, 200) =~ "New Tracker"
    end
  end

  describe "create tracker" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.tracker_path(conn, :create), tracker: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.tracker_path(conn, :show, id)

      conn = get(conn, Routes.tracker_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Tracker"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.tracker_path(conn, :create), tracker: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Tracker"
    end
  end

  describe "edit tracker" do
    setup [:create_tracker]

    test "renders form for editing chosen tracker", %{conn: conn, tracker: tracker} do
      conn = get(conn, Routes.tracker_path(conn, :edit, tracker))
      assert html_response(conn, 200) =~ "Edit Tracker"
    end
  end

  describe "update tracker" do
    setup [:create_tracker]

    test "redirects when data is valid", %{conn: conn, tracker: tracker} do
      conn = put(conn, Routes.tracker_path(conn, :update, tracker), tracker: @update_attrs)
      assert redirected_to(conn) == Routes.tracker_path(conn, :show, tracker)

      conn = get(conn, Routes.tracker_path(conn, :show, tracker))
      assert html_response(conn, 200) =~ "some updated name"
    end

    test "renders errors when data is invalid", %{conn: conn, tracker: tracker} do
      conn = put(conn, Routes.tracker_path(conn, :update, tracker), tracker: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Tracker"
    end
  end

  describe "delete tracker" do
    setup [:create_tracker]

    test "deletes chosen tracker", %{conn: conn, tracker: tracker} do
      conn = delete(conn, Routes.tracker_path(conn, :delete, tracker))
      assert redirected_to(conn) == Routes.tracker_path(conn, :index)
      assert_error_sent 404, fn ->
        get(conn, Routes.tracker_path(conn, :show, tracker))
      end
    end
  end

  defp create_tracker(_) do
    tracker = fixture(:tracker)
    %{tracker: tracker}
  end
end
