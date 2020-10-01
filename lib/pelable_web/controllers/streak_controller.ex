defmodule PelableWeb.StreakController do
  use PelableWeb, :controller

  alias Pelable.Habits
  alias Pelable.Habits.Streak

  def index(conn, _params) do
    streaks = Habits.list_streaks()
    render(conn, "index.html", streaks: streaks)
  end

  def new(conn, _params) do
    changeset = Habits.change_streak(%Streak{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"streak" => streak_params}) do
    case Habits.create_streak(streak_params) do
      {:ok, streak} ->
        conn
        |> put_flash(:info, "Streak created successfully.")
        |> redirect(to: Routes.streak_path(conn, :show, streak))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    streak = Habits.get_streak!(id)
    render(conn, "show.html", streak: streak)
  end

  def edit(conn, %{"id" => id}) do
    streak = Habits.get_streak!(id)
    changeset = Habits.change_streak(streak)
    render(conn, "edit.html", streak: streak, changeset: changeset)
  end

  def update(conn, %{"id" => id, "streak" => streak_params}) do
    streak = Habits.get_streak!(id)

    case Habits.update_streak(streak, streak_params) do
      {:ok, streak} ->
        conn
        |> put_flash(:info, "Streak updated successfully.")
        |> redirect(to: Routes.streak_path(conn, :show, streak))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", streak: streak, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    streak = Habits.get_streak!(id)
    {:ok, _streak} = Habits.delete_streak(streak)

    conn
    |> put_flash(:info, "Streak deleted successfully.")
    |> redirect(to: Routes.streak_path(conn, :index))
  end
end
