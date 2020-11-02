defmodule PelableWeb.HabitCompletionRewardController do
  use PelableWeb, :controller

  alias Pelable.Habits
  alias Pelable.Habits.HabitCompletionReward

  def index(conn, _params) do
    user = conn.assigns.current_user
    habit_completion_reward = Habits.get_user_earned_rewards(user)
    render(conn, "index.html", habit_completion_reward: habit_completion_reward)
  end


  def show(conn, %{"uuid" => uuid}) do
    habit_completion_reward = Habits.get_habit_completion_reward_by_uuid(uuid)
    render(conn, "show.html", habit_completion_reward: habit_completion_reward)
  end


  def take_reward(conn, %{"uuid" => uuid}) do
    user = conn.assigns.current_user
    earned_reward = Habits.get_habit_completion_reward_by_uuid(uuid)
    case Habits.take_earned_reward(earned_reward, user) do
      {:ok, updated_earned_reward} -> 
        json(conn, %{"taken_reward" => updated_earned_reward})

        {:error, :unauthorized} ->
          json(conn, %{"error" => "user is not unathorized to take this reward"})

          {:error, changeset} ->
            json(conn, %{"error" => changeset})
          
    end
  end

  def update(conn, %{"uuid" => uuid, "habit_completion_reward" => habit_completion_reward_params}) do
    habit_completion_reward = Habits.get_habit_completion_reward_by_uuid(uuid)

    case Habits.update_habit_completion_reward(habit_completion_reward, habit_completion_reward_params) do
      {:ok, habit_completion_reward} ->
        render(conn, "show.json", habit_completion_reward: habit_completion_reward)

      {:error, %Ecto.Changeset{} = changeset} ->
       json(conn, %{"error" => changeset})
    end
  end

  #Not allowed so far
  def delete(conn, %{"uuid" => uuid}) do
    habit_completion_reward = Habits.get_habit_completion_reward_by_uuid(uuid)

    {:ok, _habit_completion_reward} = Habits.delete_habit_completion_reward(habit_completion_reward)

    conn
    |> put_flash(:info, "Habit completion reward deleted successfully.")
    |> redirect(to: Routes.habit_completion_reward_path(conn, :index))
  end
end
