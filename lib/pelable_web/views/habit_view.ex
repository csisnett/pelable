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

  # %Habit{} -> String
  # Returns "green-habit" if the habit was completed today, otherwise "gray-habit"
  def green_or_not(%Habit{} = habit) do
    if habit.completed_today? == true do
      "green-habit"
    else
      "gray-habit"
    end
  end

  def completed_message_or_not(%Habit{} = habit) do
    if habit.completed_today? == true do
      "You have completed this habit today"
    else
      "You haven't completed this habit today yet"
    end
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
