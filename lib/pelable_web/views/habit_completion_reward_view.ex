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
    %{id: habit_completion_reward.id,
      taken?: habit_completion_reward.taken?,
      uuid: habit_completion_reward.uuid}
  end
end
