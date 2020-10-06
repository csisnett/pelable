defmodule Pelable.Habits do
  @moduledoc """
  The Habits context.
  """

  import Ecto.Query, warn: false
  alias Pelable.Repo

  alias Pelable.Users.User
  alias Pelable.Habits
  alias Pelable.Habits.{Habit, Streak, HabitCompletion, Policy}
  alias Pelable.Accounts

  defdelegate authorize(action, user, params), to: Pelable.Habits.Policy

  @doc """
  Returns the list of habits.

  ## Examples

      iex> list_habits()
      [%Habit{}, ...]

  """
  def list_habits do
    Repo.all(Habit)
  end

  @doc """
  Gets a single habit.

  Raises `Ecto.NoResultsError` if the Habit does not exist.

  ## Examples

      iex> get_habit!(123)
      %Habit{}

      iex> get_habit!(456)
      ** (Ecto.NoResultsError)

  """
  def get_habit!(id), do: Repo.get!(Habit, id)

  def get_habit_by_uuid(uuid) do
    Repo.get_by(Habit, uuid: uuid)
  end

  def get_user_timezone(%User{} = user) do
    setting = Accounts.get_user_setting("timezone", user)
    setting.value
  end

  # %User{} -> [%Habit{}, ...]
  # Produces a list of all (current and archived) user's habits
  def list_user_habits(%User{} = user) do
    query = from h in Habit, where: h.user_id == ^user.id, select: h
    Repo.all(query)
  end

  # %User{} -> [%Habit{}, ...]
  # Produces a list of a user's current habits
  def list_user_current_habits(%User{} = user) do
    query = from h in Habit, where: h.user_id == ^user.id and h.archived? == false, select: h
    Repo.all(query)
  end

  
  # %Streak{}-> %Streak{}
  #Receives a streak, calculates how many HabitCompletion has and records it in the count field
  def count_streak(%Streak{} = streak) do
    count = count_habit_completions(streak)
    streak |> Map.put(:count, count)
  end

  # %Streak{} -> Integer
  # Counts how many habit completions the Streak has
  def count_habit_completions(%Streak{} = streak) do
    [count] = Repo.all(from hc in HabitCompletion, where: hc.streak_id == ^streak.id, select: count("*"))
    count
  end

  # List, List -> List
  # Returns habits_streaks' list when there's no habits left (base case)
  def get_habits_last_streaks([], habits_streaks) when is_list(habits_streaks) do
    habits_streaks
  end

  # [%Habit{}] -> [{%Habit{}, %Streak{}}]
  # Gets the last streak for each habit and puts them in a tuple for a new list
  # Gets last streaks without any side effects
  def get_habits_last_streaks(habits, habits_streaks \\ []) when is_list(habits) do
    [this_habit | rest] = habits
    streak = get_last_streak(this_habit)
    result = {this_habit, streak}

    habits_streaks = [result | habits_streaks]
    get_habits_last_streaks(rest, habits_streaks)
  end

  # %User{} -> [{%Habit{}, %Streak{}}, ...]
  # Produces a user's current habits with their respective active streaks
  #(in case the last streak was inactive it creates a new one)
  def get_user_habits(%User{} = user) do
    habits = list_user_current_habits(user)
    user_timezone = get_user_timezone(user)
    Enum.map(habits, fn habit -> {habit, get_or_create_active_streak(habit, user_timezone) }end)
  end

  @doc """
  Creates a habit.

  ## Examples

      iex> create_habit(%{field: value})
      {:ok, %Habit{}}

      iex> create_habit(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_habit(attrs \\ %{}) do
    %Habit{}
    |> Habit.changeset(attrs)
    |> Repo.insert()
  end

  # String -> %DateTime{}
  # Creates a DateTime for the present in the timezone given.
  def create_local_present_time(timezone) do
    {:ok, local_present_time} = DateTime.now(timezone, Tzdata.TimeZoneDatabase)
    local_present_time
  end


  # %{}, %User{} -> %Habit{}
  # Creates a new habit with its initial streak for the user given.
  def create_habit(%{} = params, %User{} = user) do
    params = params |> Map.put("user_id", user.id)
    {:ok, habit} = create_habit(params)
    streak_params = %{"habit_id" => habit.id}
    create_streak(streak_params)
    {:ok, habit}
  end

  # %NaiveDateTime{}, String -> %DateTime{}
  # Converts a day & time in UTC to the equivalent day & time in another timezone
  def convert_to_local_time(%NaiveDateTime{} = naive, local_timezone) do
    {:ok, date_time} = DateTime.from_naive(naive, "Etc/UTC")
    {:ok, local_datetime} = DateTime.shift_zone(date_time, local_timezone, Tzdata.TimeZoneDatabase)
    local_datetime
  end

  
  # %NaiveDateTime{}, String -> %DateTime{}
  # Converts a NaiveDateTime to a DateTime with a timezone
  def add_timezone(%NaiveDateTime{} = naive, timezone) do
    {:ok, date_time} = DateTime.from_naive(naive, timezone, Tzdata.TimeZoneDatabase)
    date_time
  end

  # %Streak{}, String, String -> Boolean
  # Returns true if the streak is active, otherwise false
  def is_streak_active?(%Streak{} = streak, timezone, time_frequency = "daily") do
    habit_completion = get_last_habit_completion(streak)
    local_present_time = create_local_present_time(timezone)

    case habit_completion do
      nil ->
        streak_creation_time = convert_to_local_time(streak.inserted_at, timezone)
        streak_creation_time.day == local_present_time.day # true if we're in the same day the streak was created

      habit_completion ->
        completion_date = habit_completion.created_at_local_datetime |> add_timezone(timezone) |> DateTime.to_date
        present_date = local_present_time |> DateTime.to_date

        Date.diff(present_date, completion_date) <= 1 # true if habit completion was today or yesterday
    end

  end

  # %Habit{} -> %Streak{}
  # Returns the habit's last active streak. If it's inactive it creates a new streak.
  def get_or_create_active_streak(%Habit{} = habit, timezone) do
    streak = get_last_streak(habit)
    case is_streak_active?(streak, timezone, habit.time_frequency) do
      true ->
        streak = count_streak(streak)
        {:active_streak, streak}
      false -> 
        {:ok, new_streak} = create_streak(%{"habit_id" => habit.id})
        new_streak = new_streak |> Map.put(:count, 0)
        {:new_streak, new_streak}
    end
  end

  # %Habit{} -> %Streak{}
  # Returns the habit's last streak
  def get_last_streak(%Habit{} = habit) do
    query = 
    from s in Streak,
    where: s.habit_id == ^habit.id,
    order_by: [desc: s.id],
    limit: 1
    Repo.one(query)
  end

  # %Streak{} -> %HabitCompletion{}
  # Returns the streak's last habit completion
  def get_last_habit_completion(%Streak{} = streak) do
    query = 
    from hc in HabitCompletion,
    where: hc.streak_id == ^streak.id,
    order_by: [desc: hc.id],
    limit: 1
    Repo.one(query)
  end

  # %Habit{}, %User{} -> %HabitCompletion{}
  # Adds a log to this user's habit
  # Used for external calls
  def log_habit(%Habit{} = habit, %User{} = user) do
    create_habit_completion(habit, user)
  end

  # %{}, %User{} -> %HabitCompletion{}
  #Creates a HabitCompletion from a habit's uuid and a user.
  def create_habit_completion(%Habit{} = habit, %User{} = user) do

    with :ok <- Bodyguard.permit(Habits.Policy, :log_habit, user, habit) do

    timezone = get_user_timezone(user)
    
    {_, active_streak} = habit |> get_or_create_active_streak(timezone)
    
    local_present_time = create_local_present_time(timezone)

    %{}
    |> Map.put("streak_id", active_streak.id)
    |> Map.put("local_timezone", timezone) 
    |> Map.put("created_at_local_datetime", local_present_time)
    |> create_habit_completion
    end
  end

  @doc """
  Updates a habit.

  ## Examples

      iex> update_habit(habit, %{field: new_value})
      {:ok, %Habit{}}

      iex> update_habit(habit, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_habit(%Habit{} = habit, attrs) do
    habit
    |> Habit.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a habit.

  ## Examples

      iex> delete_habit(habit)
      {:ok, %Habit{}}

      iex> delete_habit(habit)
      {:error, %Ecto.Changeset{}}

  """
  def delete_habit(%Habit{} = habit) do
    Repo.delete(habit)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking habit changes.

  ## Examples

      iex> change_habit(habit)
      %Ecto.Changeset{data: %Habit{}}

  """
  def change_habit(%Habit{} = habit, attrs \\ %{}) do
    Habit.changeset(habit, attrs)
  end

  alias Pelable.Habits.Streak

  @doc """
  Returns the list of streaks.

  ## Examples

      iex> list_streaks()
      [%Streak{}, ...]

  """
  def list_streaks do
    Repo.all(Streak)
  end

  @doc """
  Gets a single streak.

  Raises `Ecto.NoResultsError` if the Streak does not exist.

  ## Examples

      iex> get_streak!(123)
      %Streak{}

      iex> get_streak!(456)
      ** (Ecto.NoResultsError)

  """
  def get_streak!(id), do: Repo.get!(Streak, id)

  @doc """
  Creates a streak.

  ## Examples

      iex> create_streak(%{field: value})
      {:ok, %Streak{}}

      iex> create_streak(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_streak(attrs \\ %{}) do
    %Streak{}
    |> Streak.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a streak.

  ## Examples

      iex> update_streak(streak, %{field: new_value})
      {:ok, %Streak{}}

      iex> update_streak(streak, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_streak(%Streak{} = streak, attrs) do
    streak
    |> Streak.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a streak.

  ## Examples

      iex> delete_streak(streak)
      {:ok, %Streak{}}

      iex> delete_streak(streak)
      {:error, %Ecto.Changeset{}}

  """
  def delete_streak(%Streak{} = streak) do
    Repo.delete(streak)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking streak changes.

  ## Examples

      iex> change_streak(streak)
      %Ecto.Changeset{data: %Streak{}}

  """
  def change_streak(%Streak{} = streak, attrs \\ %{}) do
    Streak.changeset(streak, attrs)
  end

  alias Pelable.Habits.HabitCompletion

  @doc """
  Returns the list of habitcompletion.

  ## Examples

      iex> list_habitcompletion()
      [%HabitCompletion{}, ...]

  """
  def list_habitcompletion do
    Repo.all(HabitCompletion)
  end

  @doc """
  Gets a single habit_completion.

  Raises `Ecto.NoResultsError` if the Habit completion does not exist.

  ## Examples

      iex> get_habit_completion!(123)
      %HabitCompletion{}

      iex> get_habit_completion!(456)
      ** (Ecto.NoResultsError)

  """
  def get_habit_completion!(id), do: Repo.get!(HabitCompletion, id)

  @doc """
  Creates a habit_completion.

  ## Examples

      iex> create_habit_completion(%{field: value})
      {:ok, %HabitCompletion{}}

      iex> create_habit_completion(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_habit_completion(attrs \\ %{}) do
    %HabitCompletion{}
    |> HabitCompletion.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a habit_completion.

  ## Examples

      iex> update_habit_completion(habit_completion, %{field: new_value})
      {:ok, %HabitCompletion{}}

      iex> update_habit_completion(habit_completion, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_habit_completion(%HabitCompletion{} = habit_completion, attrs) do
    habit_completion
    |> HabitCompletion.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a habit_completion.

  ## Examples

      iex> delete_habit_completion(habit_completion)
      {:ok, %HabitCompletion{}}

      iex> delete_habit_completion(habit_completion)
      {:error, %Ecto.Changeset{}}

  """
  def delete_habit_completion(%HabitCompletion{} = habit_completion) do
    Repo.delete(habit_completion)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking habit_completion changes.

  ## Examples

      iex> change_habit_completion(habit_completion)
      %Ecto.Changeset{data: %HabitCompletion{}}

  """
  def change_habit_completion(%HabitCompletion{} = habit_completion, attrs \\ %{}) do
    HabitCompletion.changeset(habit_completion, attrs)
  end

  alias Pelable.Habits.Reward

  @doc """
  Returns the list of rewards.

  ## Examples

      iex> list_rewards()
      [%Reward{}, ...]

  """
  def list_rewards do
    Repo.all(Reward)
  end

  @doc """
  Gets a single reward.

  Raises `Ecto.NoResultsError` if the Reward does not exist.

  ## Examples

      iex> get_reward!(123)
      %Reward{}

      iex> get_reward!(456)
      ** (Ecto.NoResultsError)

  """
  def get_reward!(id), do: Repo.get!(Reward, id)

  @doc """
  Creates a reward.

  ## Examples

      iex> create_reward(%{field: value})
      {:ok, %Reward{}}

      iex> create_reward(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_reward(attrs \\ %{}) do
    %Reward{}
    |> Reward.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a reward.

  ## Examples

      iex> update_reward(reward, %{field: new_value})
      {:ok, %Reward{}}

      iex> update_reward(reward, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_reward(%Reward{} = reward, attrs) do
    reward
    |> Reward.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a reward.

  ## Examples

      iex> delete_reward(reward)
      {:ok, %Reward{}}

      iex> delete_reward(reward)
      {:error, %Ecto.Changeset{}}

  """
  def delete_reward(%Reward{} = reward) do
    Repo.delete(reward)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking reward changes.

  ## Examples

      iex> change_reward(reward)
      %Ecto.Changeset{data: %Reward{}}

  """
  def change_reward(%Reward{} = reward, attrs \\ %{}) do
    Reward.changeset(reward, attrs)
  end

  alias Pelable.Habits.HabitCompletionReward

  @doc """
  Returns the list of habitcompletionreward.

  ## Examples

      iex> list_habitcompletionreward()
      [%HabitCompletionReward{}, ...]

  """
  def list_habitcompletionreward do
    Repo.all(HabitCompletionReward)
  end

  @doc """
  Gets a single habit_completion_reward.

  Raises `Ecto.NoResultsError` if the Habit completion reward does not exist.

  ## Examples

      iex> get_habit_completion_reward!(123)
      %HabitCompletionReward{}

      iex> get_habit_completion_reward!(456)
      ** (Ecto.NoResultsError)

  """
  def get_habit_completion_reward!(id), do: Repo.get!(HabitCompletionReward, id)

  @doc """
  Creates a habit_completion_reward.

  ## Examples

      iex> create_habit_completion_reward(%{field: value})
      {:ok, %HabitCompletionReward{}}

      iex> create_habit_completion_reward(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_habit_completion_reward(attrs \\ %{}) do
    %HabitCompletionReward{}
    |> HabitCompletionReward.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a habit_completion_reward.

  ## Examples

      iex> update_habit_completion_reward(habit_completion_reward, %{field: new_value})
      {:ok, %HabitCompletionReward{}}

      iex> update_habit_completion_reward(habit_completion_reward, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_habit_completion_reward(%HabitCompletionReward{} = habit_completion_reward, attrs) do
    habit_completion_reward
    |> HabitCompletionReward.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a habit_completion_reward.

  ## Examples

      iex> delete_habit_completion_reward(habit_completion_reward)
      {:ok, %HabitCompletionReward{}}

      iex> delete_habit_completion_reward(habit_completion_reward)
      {:error, %Ecto.Changeset{}}

  """
  def delete_habit_completion_reward(%HabitCompletionReward{} = habit_completion_reward) do
    Repo.delete(habit_completion_reward)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking habit_completion_reward changes.

  ## Examples

      iex> change_habit_completion_reward(habit_completion_reward)
      %Ecto.Changeset{data: %HabitCompletionReward{}}

  """
  def change_habit_completion_reward(%HabitCompletionReward{} = habit_completion_reward, attrs \\ %{}) do
    HabitCompletionReward.changeset(habit_completion_reward, attrs)
  end
end
