defmodule PelableWeb.ReminderView do
  use PelableWeb, :view

  alias Pelable.Habits.Reminder

  def create_keyword_list([], final_list) do
    final_list
  end

  def create_keyword_list(options, final_list \\ []) do
    [first | rest] = options
    keyword_tuple = {first, Atom.to_string(first)}

    final_list = [keyword_tuple | final_list]
    create_keyword_list(rest, final_list)
  end

  def hour_options do
    numbers = 0..23
    Enum.map(numbers, fn number -> :"#{number}" end)
    |> create_keyword_list
  end

  def all_frequency_options do
    [secondly: "secondly", minutely: "minutely", hourly: "hourly",
    daily: "daily", weekly: "weekly", monthly: "monthly", yearly: "yearly"]
  end

  def current_frequency_options do
    [daily: "daily"]
  end 

  def minute_options do
    numbers = 0..59
    Enum.map(numbers, fn number -> :"#{number}" end)
    |> create_keyword_list
  end

  def habit_uuid_or_not(assigns) do
    habit_uuid = Map.get(assigns, :habit_uuid)
    case habit_uuid do
      nil -> "no uuid"
      habit_uuid -> habit_uuid
    end
  end
end
