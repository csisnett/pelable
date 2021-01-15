defmodule PelableWeb.HabitController do
  use PelableWeb, :controller

  alias Pelable.Habits
  alias Pelable.Habits.{Habit, Reminder}

  def index(conn, _params) do
    conn = assign(conn, :page_title, "My Habits - Pelable")
    conn = put_resp_header(conn, "cache-control", "no-store")
    user = conn.assigns.current_user
    user_timezone = Habits.get_user_timezone(user)
    habits = Habits.get_user_habits(user)
    reminder_changeset = Habits.change_reminder(%Reminder{})
    habit_changeset = Habits.change_habit(%Habit{}, %{"time_frequency" => "daily"})
    render(conn, "index.html", habits: habits, user_info: %{"timezone" => user_timezone}, habit_changeset: habit_changeset, reminder_changeset: reminder_changeset)
  end

  def log_habit(conn, %{"uuid" => uuid} = params) do
    user = conn.assigns.current_user
    habit = Habits.get_habit_by_uuid(uuid)
    case Habits.log_habit(habit, user) do
      {:ok, habit_completion} ->

        json(conn, %{"completion" => habit_completion})

      {:ok, habit_completion, habit_completion_reward} ->
        json(conn, %{"completion" => habit_completion, "completion_reward" => habit_completion_reward})

      whatever ->
        json(conn, %{"error" => whatever})
    end
  end

  def create_reward(conn, %{"habit_uuid" => habit_uuid, "reward_name" => _name} = attrs) do
    user = conn.assigns.current_user
    habit = Habits.get_habit_by_uuid(habit_uuid)
    
    case Habits.create_reward_assign_to_habit(attrs, habit, user) do
      {:ok, reward} ->
        json(conn, %{"created_reward" => reward})

        {:error, :user_doesnt_have_permision} ->
          json(conn, %{"error" => "User doesn't have permission"})
    end
  end

  def new(conn, _params) do
    changeset = Habits.change_habit(%Habit{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"habit" => habit_params}) do
    user = conn.assigns.current_user
    case Habits.create_habit(habit_params, user) do
      {:ok, habit} ->
        conn
        |> put_flash(:info, "Habit created successfully.")
        |> redirect(to: Routes.habit_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"uuid" => uuid}) do
    habit = Habits.get_habit_by_uuid(uuid)
    render(conn, "show.html", habit: habit)
  end

  def edit(conn, %{"uuid" => uuid}) do
    habit = Habits.get_habit_by_uuid(uuid)
    changeset = Habits.change_habit(habit)
    render(conn, "edit.html", habit: habit, changeset: changeset)
  end

  def update_current_reward(conn, %{"uuid" => uuid, "reward_name" => _name} = attrs) do
    habit = Habits.get_habit_by_uuid(uuid)
    user = conn.assigns.current_user
    case Habits.update_or_create_current_reward(attrs, habit, user) do
      {:ok, reward} ->
        json(conn, %{"created_reward" => reward})

      {:error, :unauthorized} ->
        json(conn, %{"error" => "Unauthorized"})

      {:error, changeset} ->
        json(conn, %{"error" => "Error updating habit"})
    end

  end

  def create_streak_saver(conn, %{"uuid" => habit_uuid} = habit_params) do
    user = conn.assigns.current_user
    user_timezone = Habits.get_user_timezone(user)
    habit = Habits.get_habit_by_uuid(habit_uuid)
    habit_params = habit_params |> Map.put("user_timezone", user_timezone)
    case Habits.create_streak_saver(user, habit, habit_params) do
      {:ok, streak_saver} ->
        json(conn, %{"created_streak_saver" => streak_saver})

      {:error, :unauthorized} ->
        json(conn, %{"error" => "Unauthorized"})

      {:error, changeset} ->
        json(conn, %{"error" => "Error updating habit"})

    end
  end

  def update_habit(conn, %{"uuid" => uuid} = params) do
    method = params["method"]
    resource = params["resource"]

    case {method, resource} do
      {"post", "streak_saver"} -> create_streak_saver(conn, params)
      {"put", "habit"} -> update(conn, params)
    end
  end

  def update(conn, %{"uuid" => uuid} = habit_params) do
    habit = Habits.get_habit_by_uuid(uuid)

    case Habits.update_habit(habit, habit_params) do
      {:ok, habit} ->
        conn
        |> put_flash(:info, "Habit updated successfully.")
        |> redirect(to: Routes.habit_path(conn, :show, habit.uuid))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", habit: habit, changeset: changeset)
    end
  end

  def delete(conn, %{"uuid" => uuid}) do
    habit = Habits.get_habit_by_uuid(uuid)
    {:ok, _habit} = Habits.delete_habit(habit)

    conn
    |> put_flash(:info, "Habit deleted successfully.")
    |> redirect(to: Routes.habit_path(conn, :index))
  end
end
