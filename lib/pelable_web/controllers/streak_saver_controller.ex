defmodule PelableWeb.StreakSaverController do
  use PelableWeb, :controller

  alias Pelable.Habits
  alias Pelable.Habits.StreakSaver

  action_fallback PelableWeb.FallbackController

  def index(conn, _params) do
    streak_saver = Habits.list_streak_saver()
    render(conn, "index.json", streak_saver: streak_saver)
  end

  def create(conn, %{"streak_saver" => streak_saver_params}) do
    with {:ok, %StreakSaver{} = streak_saver} <- Habits.create_streak_saver(streak_saver_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.streak_saver_path(conn, :show, streak_saver))
      |> render("show.json", streak_saver: streak_saver)
    end
  end

  def show(conn, %{"id" => id}) do
    streak_saver = Habits.get_streak_saver!(id)
    render(conn, "show.json", streak_saver: streak_saver)
  end

  def update(conn, %{"id" => id, "streak_saver" => streak_saver_params}) do
    streak_saver = Habits.get_streak_saver!(id)

    with {:ok, %StreakSaver{} = streak_saver} <- Habits.update_streak_saver(streak_saver, streak_saver_params) do
      render(conn, "show.json", streak_saver: streak_saver)
    end
  end

  def delete(conn, %{"id" => id}) do
    streak_saver = Habits.get_streak_saver!(id)

    with {:ok, %StreakSaver{}} <- Habits.delete_streak_saver(streak_saver) do
      send_resp(conn, :no_content, "")
    end
  end
end
