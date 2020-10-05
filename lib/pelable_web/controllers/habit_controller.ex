defmodule PelableWeb.HabitController do
  use PelableWeb, :controller

  alias Pelable.Habits
  alias Pelable.Habits.Habit

  def index(conn, _params) do
    user = conn.assigns.current_user
    habits = Habits.get_user_habits(user)
    render(conn, "index.html", habits: habits)
  end

  def log_habit(conn, %{"uuid" => uuid} = params) do
    user = conn.assigns.current_user
    habit = Habits.get_habit_by_uuid(uuid)
    case Habits.log_habit(habit, user) do
      {:ok, habit_completion} ->

        json(conn, %{"completion" => habit_completion})
        whatever ->
          json(conn, %{"error" => whatever})
    end
  end

  def new(conn, _params) do
    changeset = Habits.change_habit(%Habit{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"habit" => habit_params}) do
    case Habits.create_habit(habit_params) do
      {:ok, habit} ->
        conn
        |> put_flash(:info, "Habit created successfully.")
        |> redirect(to: Routes.habit_path(conn, :show, habit))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    habit = Habits.get_habit!(id)
    render(conn, "show.html", habit: habit)
  end

  def edit(conn, %{"id" => id}) do
    habit = Habits.get_habit!(id)
    changeset = Habits.change_habit(habit)
    render(conn, "edit.html", habit: habit, changeset: changeset)
  end

  def update(conn, %{"id" => id, "habit" => habit_params}) do
    habit = Habits.get_habit!(id)

    case Habits.update_habit(habit, habit_params) do
      {:ok, habit} ->
        conn
        |> put_flash(:info, "Habit updated successfully.")
        |> redirect(to: Routes.habit_path(conn, :show, habit))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", habit: habit, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    habit = Habits.get_habit!(id)
    {:ok, _habit} = Habits.delete_habit(habit)

    conn
    |> put_flash(:info, "Habit deleted successfully.")
    |> redirect(to: Routes.habit_path(conn, :index))
  end
end
