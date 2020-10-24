defmodule PelableWeb.HabitView do
  use PelableWeb, :view

  alias Pelable.Habits
  alias Pelable.Habits.{Habit, Streak}

  # %Streak{}, String, String -> Integer || String
  # Use to show the streak count beside the checkmark
  # If the given streak is current returns its count otherwise empty string
  def show_streak_count_or_not(%Streak{} = streak, timezone, habit_frequency) do
    case Habits.is_streak_current?(streak, timezone, habit_frequency) do
      true -> streak.count
      false -> ""
    end
  end

  # %Habit{} -> String
  # Creates the id for a habit's reward form
  def form_name(%Habit{} = habit) do
    name = "form_reward_" <> habit.uuid
  end

  # %Habit{} -> String
  # Use to show the habit's status as green or gray.
  #Returns "green-habit" if the habit was completed today, otherwise "gray-habit"
  def green_or_not(%Habit{} = habit) do
    if habit.completed_today? == true do
      "green-habit"
    else
      "gray-habit"
    end
  end

  #%Habit{} -> String
  # Use to determine the popover message for the habit status
  def completed_message_or_not(%Habit{} = habit) do
    if habit.completed_today? == true do
      "This habit is finished for today"
    else
      "This habit isn't finished for today yet"
    end
  end

  # %Habit{} -> IOdata
  # Creates a form for a new reward for a specific habit
  def form_for_new_reward(%Habit{} = habit) do
    name = form_name(habit)
    raw(
      
    "<form id='#{name}'>
    <label for='reward_name'>Name</label><input id='reward_name' name='reward[name]' type='text'>  <br>
    <label for='reward_description'>Description (optional)</label><textarea id='reward_description' name='reward[description]'>
    </textarea>
    </form>")
  end

  def reminder_message([], explanations) do
    explanations_msg = Enum.join(explanations, " and ")
    if length(explanations) == 1 do
    "Reminder: " <> explanations_msg
    else
      "Reminders: " <> explanations_msg
    end
  end

  # [] -> String
  def reminder_message(reminders, explanations) when is_list(reminders) do
    [first_reminder | rest] = reminders
    first_explanation = Habits.explain_reminder(first_reminder)
    
    reminder_message(rest, [first_explanation | explanations])
  end

  def show_reminders_times([], times) do
    #I need to finish it or delete it
    times
  end

  def show_reminders_times(reminders, times) when is_list(reminders) do
    [first_reminder, rest] = reminders
    time_string = first_reminder.start_time |> Time.to_string
    times = [time_string | times]
    show_reminders_times(rest, times)
  end
 

end
