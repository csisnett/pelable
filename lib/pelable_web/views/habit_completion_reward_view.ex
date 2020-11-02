defmodule PelableWeb.HabitCompletionRewardView do
  use PelableWeb, :view
  alias PelableWeb.HabitCompletionRewardView
  
  def render("index.json", %{habitcompletionreward: habitcompletionreward}) do
      %{data: render_many(habitcompletionreward, HabitCompletionRewardView, "habit_completion_reward.json")}
  end
  
  def render("show.json", %{habit_completion_reward: habit_completion_reward}) do
      %{data: render_one(habit_completion_reward, HabitCompletionRewardView, "habit_completion_reward.json")}
  end
  
  def render("habit_completion_reward.json", %{habit_completion_reward: habit_completion_reward}) do
      %{uuid: habit_completion_reward.uuid,
        taken_at_local: habit_completion_reward.taken_at_local,
        local_timezone: habit_completion_reward.local_timezone}
  end
end
