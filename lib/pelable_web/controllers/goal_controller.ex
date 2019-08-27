defmodule PelableWeb.GoalController do
  use PelableWeb, :controller

  alias Pelable.Learn
  alias Pelable.Learn.Goal

  def index(conn, _params) do
    goals = Learn.list_goals()
    render(conn, "index.html", goals: goals)
  end

  def new(conn, _params) do
    changeset = Learn.change_goal(%Goal{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"goal" => goal_params}) do
    case Learn.create_goal(goal_params) do
      {:ok, goal} ->
        conn
        |> put_flash(:info, "Goal created successfully.")
        |> redirect(to: Routes.goal_path(conn, :show, goal))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    goal = Learn.get_goal!(id)
    render(conn, "show.html", goal: goal)
  end

  def edit(conn, %{"id" => id}) do
    goal = Learn.get_goal!(id)
    changeset = Learn.change_goal(goal)
    render(conn, "edit.html", goal: goal, changeset: changeset)
  end

  def update(conn, %{"id" => id, "goal" => goal_params}) do
    goal = Learn.get_goal!(id)

    case Learn.update_goal(goal, goal_params) do
      {:ok, goal} ->
        conn
        |> put_flash(:info, "Goal updated successfully.")
        |> redirect(to: Routes.goal_path(conn, :show, goal))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", goal: goal, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    goal = Learn.get_goal!(id)
    {:ok, _goal} = Learn.delete_goal(goal)

    conn
    |> put_flash(:info, "Goal deleted successfully.")
    |> redirect(to: Routes.goal_path(conn, :index))
  end
end
