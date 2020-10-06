defmodule PelableWeb.HabitCompletionRewardController do
  use PelableWeb, :controller

  alias Pelable.Habits
  alias Pelable.Habits.HabitCompletionReward

  action_fallback PelableWeb.FallbackController

  def index(conn, _params) do
    habitcompletionreward = Habits.list_habitcompletionreward()
    render(conn, "index.json", habitcompletionreward: habitcompletionreward)
  end

  def create(conn, %{"habit_completion_reward" => habit_completion_reward_params}) do
    with {:ok, %HabitCompletionReward{} = habit_completion_reward} <- Habits.create_habit_completion_reward(habit_completion_reward_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.habit_completion_reward_path(conn, :show, habit_completion_reward))
      |> render("show.json", habit_completion_reward: habit_completion_reward)
    end
  end

  def show(conn, %{"id" => id}) do
    habit_completion_reward = Habits.get_habit_completion_reward!(id)
    render(conn, "show.json", habit_completion_reward: habit_completion_reward)
  end

  def update(conn, %{"id" => id, "habit_completion_reward" => habit_completion_reward_params}) do
    habit_completion_reward = Habits.get_habit_completion_reward!(id)

    with {:ok, %HabitCompletionReward{} = habit_completion_reward} <- Habits.update_habit_completion_reward(habit_completion_reward, habit_completion_reward_params) do
      render(conn, "show.json", habit_completion_reward: habit_completion_reward)
    end
  end

  def delete(conn, %{"id" => id}) do
    habit_completion_reward = Habits.get_habit_completion_reward!(id)

    with {:ok, %HabitCompletionReward{}} <- Habits.delete_habit_completion_reward(habit_completion_reward) do
      send_resp(conn, :no_content, "")
    end
  end
end
