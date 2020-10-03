defmodule PelableWeb.HabitCompletionController do
  use PelableWeb, :controller

  alias Pelable.Habits
  alias Pelable.Habits.HabitCompletion

  def index(conn, _params) do
    habitcompletion = Habits.list_habitcompletion()
    render(conn, "index.html", habitcompletion: habitcompletion)
  end

  def new(conn, _params) do
    changeset = Habits.change_habit_completion(%HabitCompletion{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"habit_completion" => habit_completion_params}) do
    case Habits.create_habit_completion(habit_completion_params) do
      {:ok, habit_completion} ->
        conn
        |> put_flash(:info, "Habit completion created successfully.")
        |> redirect(to: Routes.habit_completion_path(conn, :show, habit_completion))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    habit_completion = Habits.get_habit_completion!(id)
    render(conn, "show.html", habit_completion: habit_completion)
  end

  def edit(conn, %{"id" => id}) do
    habit_completion = Habits.get_habit_completion!(id)
    changeset = Habits.change_habit_completion(habit_completion)
    render(conn, "edit.html", habit_completion: habit_completion, changeset: changeset)
  end

  def update(conn, %{"id" => id, "habit_completion" => habit_completion_params}) do
    habit_completion = Habits.get_habit_completion!(id)

    case Habits.update_habit_completion(habit_completion, habit_completion_params) do
      {:ok, habit_completion} ->
        conn
        |> put_flash(:info, "Habit completion updated successfully.")
        |> redirect(to: Routes.habit_completion_path(conn, :show, habit_completion))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", habit_completion: habit_completion, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    habit_completion = Habits.get_habit_completion!(id)
    {:ok, _habit_completion} = Habits.delete_habit_completion(habit_completion)

    conn
    |> put_flash(:info, "Habit completion deleted successfully.")
    |> redirect(to: Routes.habit_completion_path(conn, :index))
  end
end
