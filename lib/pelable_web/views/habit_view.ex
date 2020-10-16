defmodule PelableWeb.HabitView do
  use PelableWeb, :view

  alias Pelable.Habits
  alias Pelable.Habits.{Habit, Streak}

  def show_streak_count_or_not(%Streak{} = streak, timezone, habit_frequency) do
    case Habits.is_streak_current?(streak, timezone, habit_frequency) do
      true -> streak.count
      false -> ""
    end
  end

  def form_name(%Habit{} = habit) do
    name = "form_reward_" <> habit.uuid
  end

  def form_for_new_reward(%Habit{} = habit) do
    name = form_name(habit)
    raw(
      
    "<form id='#{name}'>
    <label for='reward_name'>Name</label><input id='reward_name' name='reward[name]' type='text'>  <br>
    <label for='reward_description'>Description (optional)</label><textarea id='reward_description' name='reward[description]'>
    </textarea>
    </form>")
  end
end
