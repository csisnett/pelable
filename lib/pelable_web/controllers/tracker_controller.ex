defmodule PelableWeb.TrackerController do
  use PelableWeb, :controller

  alias Pelable.Habits
  alias Pelable.Habits.Tracker

  def index(conn, _params) do
    trackers = Habits.list_trackers()
    render(conn, "index.html", trackers: trackers)
  end

  def new(conn, _params) do
    changeset = Habits.change_tracker(%Tracker{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"tracker" => tracker_params}) do
    user = conn.assigns.current_user
    case Habits.create_tracker_and_first_activity(tracker_params, user) do
      {:ok, %{"tracker" => tracker, "activity" => activity}} ->

        json(conn, %{"created_tracker" => tracker, "created_activity" => activity})

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def create_new_activity(conn, %{"uuid" => uuid} = activity_params) do
    user = conn.assigns.current_user
    activity_params = activity_params |> Map.put("tracker_uuid", uuid)
    case Habits.add_new_activity!(activity_params, user) do
      {:ok, activity} ->

        json(conn, %{"created_activity" => activity})

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def terminate_tracker(conn, %{"uuid" => uuid}) do
    user = conn.assigns.current_user
    tracker = Habits.get_tracker_by_uuid(uuid)
    case Habits.stop_tracker(tracker, user) do
      {:ok, %{"stopped_tracker" => tracker, "activities" => activities}} ->

        json(conn, %{"tracker" => tracker, "activities" => activities})

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    tracker = Habits.get_tracker!(id)
    render(conn, "show.html", tracker: tracker)
  end

  def edit(conn, %{"id" => id}) do
    tracker = Habits.get_tracker!(id)
    changeset = Habits.change_tracker(tracker)
    render(conn, "edit.html", tracker: tracker, changeset: changeset)
  end

  def update(conn, %{"id" => id, "tracker" => tracker_params}) do
    tracker = Habits.get_tracker!(id)

    case Habits.update_tracker(tracker, tracker_params) do
      {:ok, tracker} ->
        conn
        |> put_flash(:info, "Tracker updated successfully.")
        |> redirect(to: Routes.tracker_path(conn, :show, tracker))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", tracker: tracker, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    tracker = Habits.get_tracker!(id)
    {:ok, _tracker} = Habits.delete_tracker(tracker)

    conn
    |> put_flash(:info, "Tracker deleted successfully.")
    |> redirect(to: Routes.tracker_path(conn, :index))
  end
end
