defmodule Pelable.Habits do
  @moduledoc """
  The Habits context.
  """

  import Ecto.Query, warn: false
  alias Pelable.Repo

  alias Pelable.Users.User
  alias Pelable.Habits
  alias Pelable.Habits.{Habit, Streak, HabitCompletion, Reward, Policy}
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

  # %User{} -> Ecto.Query{}
  # Produces a query to list a user's current habits
  def list_user_current_habits(%User{} = user) do
    query = from h in Habit, where: h.user_id == ^user.id and h.archived? == false
  end

  # Gets a query of habits and produces a new query with their respective reminders
  def query_reminders(query) do
    from habit in query,
    left_join: habit_reminder in assoc(habit, :habit_reminder),
    left_join: reminder in assoc(habit_reminder, :reminder),
    preload: [reminders: reminder] 
  end

  
  # %Streak{}-> %Streak{}
  #Receives a streak, counts how many HabitCompletion has and records it in the count field
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
  # Returns habits_streaks' list when there's no habits left to go through (base case)
  def get_habits_last_streaks([], _user_timezone, habits_streaks) when is_list(habits_streaks) do
    habits_streaks
  end

  # [%Habit{}] -> [{%Habit{}, %Streak{}}]
  # Gets the last streak for each habit and returns it along with its habit
  # For streaks it adds how many  habit completions (count), for habits whether they should be completed today (complete_now?)
  def get_habits_last_streaks(habits, user_timezone, habits_streaks \\ []) when is_list(habits) do
    [this_habit | rest] = habits
    
    this_habit = complete_habit_now(this_habit, user_timezone)
    last_streak = get_last_streak(this_habit)
    result = {this_habit, count_streak(last_streak)}

    habits_streaks = [result | habits_streaks]
    get_habits_last_streaks(rest, user_timezone,  habits_streaks)
  end


  # %Habit{}, String -> %Habit{}
  # fills in habit's complete_now? with true if the user should complete the habit right now
  # Used when sending habits to a user 
  def complete_habit_now(%Habit{} = habit, timezone) when is_binary(timezone) do
    complete_now? = complete_this_habit?(habit, timezone) 
    Map.put(habit, :complete_now?, complete_now?)
  end

  # %Habit{}, String -> Boolean
  #Returns true if the user should complete this habit right now otherwise false
  def complete_this_habit?(%Habit{time_frequency: "weekly"} = habit, timezone) do
    last_streak = get_last_streak(habit)
    last_habit_completion = get_last_habit_completion(last_streak)
    local_present_datetime = create_local_present_datetime(timezone)

    case last_habit_completion do
      nil -> true # true if the habit has never been completed
      last_habit_completion ->
        last_completion_date = last_habit_completion.created_at_local_datetime |> add_timezone(timezone) |> DateTime.to_date
        present_date = local_present_datetime |> DateTime.to_date
        Date.end_of_week(last_completion_date) != Date.end_of_week(present_date) # True if we're not in the same week of the last habit completion
    end
    
  end
  # %Habit{}, String -> Boolean
  #Returns true if the user should complete this habit today otherwise false
  def complete_this_habit?(%Habit{time_frequency: "daily"} = habit,  timezone) do
    last_streak = get_last_streak(habit)
    last_habit_completion = get_last_habit_completion(last_streak)
    local_present_datetime = create_local_present_datetime(timezone)
    
    case last_habit_completion do
      nil -> true # true if the habit has never been completed
      last_habit_completion ->
        last_completion_date = last_habit_completion.created_at_local_datetime |> add_timezone(timezone) |> DateTime.to_date
        present_date = local_present_datetime |> DateTime.to_date
        Date.diff(present_date, last_completion_date) != 0 # true if the completion date wasn't today
    end
  end

  # %User{} -> [{%Habit{}, %Streak{}}, ...]
  # Produces a user's current habits with their respective active streaks
  #(in case the last streak was inactive it creates a new one)
  def get_user_habits(%User{} = user) do
    habits = list_user_current_habits(user) |> query_reminders |> Repo.all
    user_timezone = get_user_timezone(user)
    get_habits_last_streaks(habits, user_timezone)
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
  def create_local_present_datetime(timezone) do
    {:ok, local_present_datetime} = DateTime.now(timezone, Tzdata.TimeZoneDatabase)
    local_present_datetime
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
  def convert_utc_to_local_datetime(%NaiveDateTime{} = naive, local_timezone) do
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
  # Returns true if the streak is alive, otherwise false
  def is_streak_alive?(%Streak{} = streak, timezone, time_frequency = "daily") do
    last_habit_completion = get_last_habit_completion(streak)
    local_present_datetime = create_local_present_datetime(timezone)

    case last_habit_completion do
      nil ->
        streak_creation_datetime = convert_utc_to_local_datetime(streak.inserted_at, timezone)
        streak_creation_datetime.day == local_present_datetime.day # true if we're in the same day the streak was created

      last_habit_completion ->
        last_completion_date = last_habit_completion.created_at_local_datetime |> add_timezone(timezone) |> DateTime.to_date
        present_date = local_present_datetime |> DateTime.to_date

        Date.diff(present_date, last_completion_date) <= 1 # true if habit completion was today or yesterday
    end
  end

  # %Streak{}, String, String -> Boolean
  # Returns true if the streak is alive, otherwise false
  def is_streak_alive?(%Streak{} = streak, timezone, time_frequency = "weekly") do
    last_habit_completion = get_last_habit_completion(streak)
    local_present_datetime = create_local_present_datetime(timezone)
    present_date = local_present_datetime |> DateTime.to_date

    case last_habit_completion do
      nil ->
        streak_creation_date = convert_utc_to_local_datetime(streak.inserted_at, timezone) |> DateTime.to_date
        Date.end_of_week(streak_creation_date) == Date.end_of_week(present_date) # true if we're in the same week the streak was created

      last_habit_completion ->
        last_completion_date = last_habit_completion.created_at_local_datetime |> add_timezone(timezone) |> DateTime.to_date
    
        last_day_of_the_week = Date.end_of_week(last_completion_date, :default) #default: the week starts on monday

        Date.diff(present_date, last_day_of_the_week) <= 7 # true if we're on the next week from the last habit completion date
      end
  end

  # %Habit{} -> %Streak{}
  # Returns the habit's last active streak. If it's inactive it creates a new streak.
  def get_or_create_current_streak(%Habit{} = habit, timezone) do
    streak = get_last_streak(habit)
    case is_streak_alive?(streak, timezone, habit.time_frequency) do
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

  # %Habit{}, %User{} -> {:ok, %HabitCompletion{}} || {:ok, %HabitCompletion{}, %HabitCompletionReward{}}
  # Adds a log to this user's habit
  # Used for external calls
  def log_habit(%Habit{} = habit, %User{} = user) do
    {:ok, habit_completion} = create_habit_completion(habit, user)
    
    case habit.current_reward_id do
      nil -> {:ok, habit_completion}
      _any_id -> maybe_win_reward(habit, habit_completion)
    end
  end

  def explain_completion_recommendation(%Habit{complete_now?: true, time_frequency: "daily"} = habit) do
    "This habit isn't finished for today"
  end

  def explain_completion_recommendation(%Habit{complete_now?: false, time_frequency: "daily"} = habit) do
    "This habit is finished for today"
  end

  def explain_completion_recommendation(%Habit{complete_now?: true, time_frequency: "weekly"} = habit) do
    "This habit isn't finished for the week"
  end

  def explain_completion_recommendation(%Habit{complete_now?: false, time_frequency: "weekly"} = habit) do
    "This habit is finished for the week"
  end

  # %{}, %User{} -> {:ok, %HabitCompletion{}} || {:error, %Changeset{}}
  #Creates a HabitCompletion from a habit's uuid and a user.
  def create_habit_completion(%Habit{} = habit, %User{} = user) do

    with :ok <- Bodyguard.permit(Habits.Policy, :log_habit, user, habit) do

      timezone = get_user_timezone(user)
    
      {_, alive_streak} = habit |> get_or_create_current_streak(timezone)
    
      local_present_datetime = create_local_present_datetime(timezone)

      {:ok, habit_completion} = 
      %{}
      |> Map.put("streak_id", alive_streak.id)
      |> Map.put("local_timezone", timezone) 
      |> Map.put("created_at_local_datetime", local_present_datetime)
      |> create_habit_completion

      habit = complete_habit_now(habit, timezone)
      completion_recommendation = explain_completion_recommendation(habit)
      habit_completion = habit_completion |> Map.put(:completion_recommendation, completion_recommendation)

      {:ok, habit_completion}
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

  # %{}, %User{} -> {:ok, %Habit{}}
  # Gets habit and reward from uuids and update the habit's current reward with the reward given.
  def update_habit_current_reward(%{"habit_uuid" => habit_uuid, "reward_uuid" => reward_uuid}, %User{} = user) do
    habit = get_habit_by_uuid(habit_uuid)
    reward = get_reward_by_uuid(reward_uuid)
    update_habit_current_reward(habit, reward, user)
  end

  # %Habit{}, %Reward{}, %User{} -> {:ok, %Habit{}}
  # Updates the habit's current reward to the reward given
  def update_habit_current_reward(%Habit{} = habit, %Reward{} = reward, %User{} = user) do
    with :ok <- Bodyguard.permit(Habits.Policy, :update_habit, user, habit),
         :ok <- Bodyguard.permit(Habits.Policy, :update_reward, user, reward) do
        attrs = %{"current_reward_id" => reward.id}
        update_habit(habit, attrs)
    end
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

  def get_reward_by_uuid(uuid), do: Repo.get_by(Reward, uuid: uuid)

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

  # %{}, %User{} -> {:ok, %Reward{}}
  # Creates a new reward for the user with the params given
  def create_reward(attrs = %{}, %User{} = user) do
    attrs |> Map.put("creator_id", user.id) |> create_reward
  end

  def update_or_create_current_reward(attrs =  %{}, %Habit{} = habit, %User{} = user) do
    case attrs["reward_uuid"]  do
      nil -> create_reward_and_assign_to_habit(attrs, habit, user)
      uuid ->
        reward = get_reward_by_uuid(uuid)
        update_habit_current_reward(habit,reward, user)
    end
  end

  # %{}, %Habit{}, %User{} -> {:ok, reward} || {:error, :unauthorized} || {:error, %Changeset{}}
  #Creates a reward and assigns it to this habit if the user owns it
  def create_reward_and_assign_to_habit(attrs = %{}, %Habit{} = habit, %User{} = user) do
    new_attrs = attrs |> Map.put("creator_id", user.id) |> Map.put("name", attrs["reward_name"]) |> Map.put("description", attrs["reward_description"])
     with :ok <- Bodyguard.permit(Habits.Policy, :update_habit, user, habit),
     {:ok, reward} <- create_reward(new_attrs),
      {:ok, _updated_habit} <- update_habit_current_reward(habit, reward, user) do
        {:ok, reward}
    end
  end

  # %Habit{}, %HabitCompletion{} -> {:ok, %HabitCompletion{}, %HabitCompletionReward{} } || {:ok, %HabitCompletion{} }
  # 50% of the time creates a new earned reward for the habit completion given.

  def maybe_win_reward(%Habit{} = habit, %HabitCompletion{} = habit_completion) do
    random_number = Enum.random(1..100)
    if random_number > 50 do
      attrs = %{"reward_id" => habit.current_reward_id, "habit_completion_id" => habit_completion.id, "creator_id" => habit.user_id}
      {:ok, habit_completion_reward} = create_habit_completion_reward(attrs)
      habit_completion_reward = habit_completion_reward |> Repo.preload([:reward])
      {:ok, habit_completion, habit_completion_reward}
    else
      # No reward gained
      {:ok, habit_completion}
    end
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

  def get_habit_completion_reward_by_uuid(uuid), do: Repo.get_by(HabitCompletionReward, uuid: uuid)

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

  # %HabitCompletionReward{}, %User{} -> {:ok, %HabitCompletionReward{}} || {:error, :unauthorized} || {:error, %Changeset{}}
  # Marks an Earned reward as taken with the present local time
  def take_earned_reward(%HabitCompletionReward{} = earned_reward, %User{} = user) do

   with :ok <- Bodyguard.permit(Habits.Policy, :take_earned_reward, user, earned_reward) do
    timezone = get_user_timezone(user)
    local_time_now = create_local_present_datetime(timezone)

    attrs = %{"taken_at_local" => local_time_now, "local_timezone" => timezone}
    update_habit_completion_reward(earned_reward, attrs)
   end
  end

  # %User{} -> [%Reward{earned_rewards: [%HabitCompletionReward{}, ...]} ...]
  # Get the user's rewards and their earned rewards
  def get_user_earned_rewards(%User{} = user) do
    query = 
    from e in HabitCompletionReward,
    where: e.creator_id == ^user.id,
    select: e
    Repo.all(query)
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

  alias Pelable.Habits.Reminder

  @doc """
  Returns the list of reminders.

  ## Examples

      iex> list_reminders()
      [%Reminder{}, ...]

  """
  def list_reminders do
    Repo.all(Reminder)
  end

  @doc """
  Gets a single reminder.

  Raises `Ecto.NoResultsError` if the Reminder does not exist.

  ## Examples

      iex> get_reminder!(123)
      %Reminder{}

      iex> get_reminder!(456)
      ** (Ecto.NoResultsError)

  """
  def get_reminder!(id), do: Repo.get!(Reminder, id)

  def get_reminder_by_uuid(uuid), do: Repo.get_by(Reminder, uuid: uuid)

  @doc """
  Creates a reminder.

  ## Examples

      iex> create_reminder(%{field: value})
      {:ok, %Reminder{}}

      iex> create_reminder(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_reminder(attrs \\ %{}) do
    %Reminder{}
    |> Reminder.changeset(attrs)
    |> Repo.insert()
  end

  # %Reminder{} -> Boolean
  # Determines whether the reminder is recurrent
  def recurrent_reminder?(%Reminder{} = reminder) do
    if reminder.time_frequency == nil do
      false
    else
      true
    end
  end

  # Explains when a recurrent reminder goes off
  def explain_recurrent_reminder(%Reminder{time_frequency: time_frequency} = reminder) do
    case time_frequency do
      "daily" ->
        time_string = Time.to_string(reminder.time_start) |> String.slice(0..4)
        "every day at " <> time_string
    end
  end

  # Explains when a one-off reminder goes off
  def explain_specific_date_reminder(%Reminder{} = reminder) do
    local_datetime = create_local_present_datetime(reminder.local_timezone)
    local_date = DateTime.to_date(local_datetime)
    days_ahead = DateTime.diff(reminder.start_date, local_date)
    time_string = reminder.start_time |> Time.to_string |> String.slice(0..4) #Eliminates seconds from string

    case days_ahead do
      0 -> "Today at " <> time_string
      1 -> "Tomorrow at " <> time_string
      n -> "In #{n} days at " <> time_string
    end
  end

  # Explains when the reminder given will go off
  def explain_reminder(%Reminder{} = reminder) do
      case recurrent_reminder?(reminder) do
        true -> explain_recurrent_reminder(reminder)
        false -> explain_specific_date_reminder(reminder)
      end
  end

  # %{} -> %{}
  # If a date is not given gets the present date at the local timezone and assigns it to "date_start"
  # Makes sure there's always a date_start for new reminders
  def create_date_start(attrs) do
    with false <- Map.has_key?(attrs, "start_date_option") do
      datetime = create_local_present_datetime(attrs["local_timezone"])
      date = DateTime.to_date(datetime)
      attrs |> Map.put("date_start", date)
    end
  end

  # %{} -> %{}
  # Creates %Time{} using the attrs time_hour and time_minute and assigns it as "time_start" 
  # Basically turns incoming data into Time for a new Reminder
  def create_time_start(attrs) do
    with true <- Map.has_key?(attrs, "time_hour"),
    true <- Map.has_key?(attrs, "time_minute")
    do
      time_hour = String.to_integer(attrs["time_hour"])
      time_minute = String.to_integer(attrs["time_minute"])
      {:ok, time_start} = Time.new(time_hour, time_minute, 0)
      attrs |> Map.put("time_start", time_start)
    else
      false -> attrs
    end
  end

  #Currently not in use
  # %{}, %Habit{}, %User{} -> {:ok, %Reminder{}, %HabitReminder{}} || {:error, :unauthorized}
  # Creates a reminder for the habit given if the user owns the habit.
  def create_reminder_for_habit(%{} = attrs, %Habit{} = habit, %User{} = user) do
    with :ok <- Bodyguard.permit(Habits.Policy, :update_habit, user, habit) do
      {:ok, reminder} = create_reminder(attrs, user)
      habit_reminder_attrs = %{"reminder_id" => reminder.id, "habit_id" => habit.id}
      {:ok, habit_reminder} = create_habit_reminder(habit_reminder_attrs)
      {:ok, reminder, habit_reminder}
    end
  end

  # %{}, %User{} -> {:ok, %Reminder{}} || {:ok, %Reminder{}, %HabitReminder{}} || {:error, %Ecto.Changeset{}}
  # Creates a new reminder for the user given
  def create_reminder(%{} = attrs, %User{} = user) do
    with :ok <- Bodyguard.permit(Habits.Policy, :create_reminder, user, attrs) do
      case Map.get(attrs, "recurrent") do
        "true" -> create_recurrent_reminder(attrs, user)
        "false" -> create_one_off_reminder(attrs, user)
      end
    end
  end

  def if_habit_create_habit_reminder(%{"habit_uuid" => "no uuid"}, reminder, user) do
    {:ok, reminder}
  end

  # # %{}, %Reminder{}, %User{} -> {:ok, %Reminder{}, %HabitReminder{} || {:ok, %Reminder{}}
  # Creates a habit_reminder with the Reminder and habit_uuid given
  # Used when creating reminders for a specific habit
  def if_habit_create_habit_reminder(%{"habit_uuid" => uuid} = attrs, %Reminder{} = reminder, %User{} = user) do
    habit = Habits.get_habit_by_uuid(uuid)
    case habit do
      nil -> {:ok, reminder}
      %Habit{} ->
        with :ok <- Bodyguard.permit(Habits.Policy, :update_habit, user, habit) do
          attrs = %{"habit_id" => habit.id, "reminder_id" => reminder.id}
          {:ok, habit_reminder} = create_habit_reminder(attrs)
          {:ok, reminder, habit_reminder}
      end
    end
  end

  # If the above function doesn't match (there's no habit_uuid) just return the reminder itself
  def if_habit_create_habit_reminder(%{} = _attrs, %Reminder{} = reminder, %User{} = _user) do
    {:ok, reminder}
  end

  
  # %{}, %User{} -> {:ok, %Reminder{}} || {:ok, %Reminder{}, %HabitReminder{}} || {:error, Ecto.Changeset{}}
  # Used to create recurrent reminders
  def create_recurrent_reminder(%{} = attrs, user) do
    attrs = attrs |> create_time_start |> create_date_start
    case Reminder.recurrent_changeset(%Reminder{}, attrs) |> Repo.insert() do
      {:ok, reminder} -> if_habit_create_habit_reminder(attrs, reminder, user)
        {:error, changeset} -> {:error, changeset}
    end
  end

  # %{}, %User{} -> {:ok, %Reminder{}} || {:ok, %Reminder{}, %HabitReminder{}} || {:error, Ecto.Changeset{}}
  # Used to create one-off reminders
  def create_one_off_reminder(%{} = attrs, user) do
    attrs = attrs |> create_time_start
    case create_reminder(attrs) do
      {:ok, reminder} -> if_habit_create_habit_reminder(attrs, reminder, user)
        {:error, changeset} -> {:error, changeset}
    end
  end

  @doc """
  Updates a reminder.

  ## Examples

      iex> update_reminder(reminder, %{field: new_value})
      {:ok, %Reminder{}}

      iex> update_reminder(reminder, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_reminder(%Reminder{} = reminder, attrs) do
    reminder
    |> Reminder.changeset(attrs)
    |> Repo.update()
  end

  # %Reminder{} -> Integer
  # Returns the # of seconds for the reminder to go off
  def time_for_reminder(%Reminder{time_frequency: nil} = reminder) do
    {:ok, datetime} = DateTime.new(reminder.date_start, reminder.time_start, reminder.local_timezone, Tzdata.TimeZoneDatabase)
    {:ok, reminder_utc_datetime} = DateTime.shift_zone(datetime, "Etc/UTC", Tzdata.TimeZoneDatabase)
    {:ok, present_datetime} = DateTime.now("Etc/UTC")
    DateTime.diff(reminder_utc_datetime, present_datetime, :second) # if > 0 reminder is in the future. 
  end

  # Recurrent first time is calculated like a one off
  def time_for_reminder(%Reminder{time_frequency: "daily"} = reminder, "first_day") do
    {:ok, datetime} = DateTime.new(reminder.date_start, reminder.time_start, reminder.local_timezone, Tzdata.TimeZoneDatabase)
    {:ok, reminder_utc_datetime} = DateTime.shift_zone(datetime, "Etc/UTC", Tzdata.TimeZoneDatabase)
    {:ok, present_datetime} = DateTime.now("Etc/UTC")
    DateTime.diff(reminder_utc_datetime, present_datetime, :second) # if > 0 reminder is in the future. 
  end

  # Recurrent following times you need to calculate the time for the next day not the current day oh it depends on the day start actually.
  def time_for_reminder(%Reminder{time_frequency: "daily"} = reminder) do
    local_present_datetime = create_local_present_datetime(reminder.local_timezone)
    next_date = DateTime.to_date(local_present_datetime) |> Date.add(1)
    {:ok, next_datetime} = DateTime.new(next_date, reminder.time_start, reminder.local_timezone, Tzdata.TimeZoneDatabase)

    DateTime.diff(next_datetime, local_present_datetime, :second)
  end

  # %Reminder{} -> String
  # Converts the date time the reminder will go off to a string
   # This just illustrates one date time if it's recurrent there will be more
  # Not in used currently
  def reminder_to_datetime_string(%Reminder{} = reminder) do
    {:ok, datetime} = DateTime.new(reminder.date_start, reminder.time_start, reminder.local_timezone, Tzdata.TimeZoneDatabase)
    DateTime.to_string(datetime)
  end

  def push_test(uuid) do
    reminder = get_reminder_by_uuid(uuid)
    send_reminder_to_one_signal(reminder)
  end

  # Used for one off reminders
  def schedule_reminder(%Reminder{uuid: uuid, time_frequency: nil} = reminder) do
    time_for_reminder = time_for_reminder(reminder)
    params = %{"reminder_uuid" => uuid}
    params |> Pelable.PushNotification.new(schedule_in: time_for_reminder) |> Oban.insert()
  end

  # Used for recurrent reminders
  def schedule_reminder(%Reminder{uuid: uuid, time_frequency: _frequency} = reminder) do
    time_for_reminder = time_for_reminder(reminder, "first_day")
    params = %{"reminder_uuid" => uuid}
    params |> Pelable.RecurrentPushNotification.new(schedule_in: time_for_reminder) |> Oban.insert()
  end

  # Used to push notification of one signal (pass it to send_push_notification)
  def test_notification do
    {:ok, dt } = DateTime.now("America/Panama", Tzdata.TimeZoneDatabase)
    dt = dt |> DateTime.add(180, :second, Tzdata.TimeZoneDatabase)
    time_string = dt |> DateTime.to_time |> Time.to_string |> String.slice(0..4)
    %{"title" => "Test notification",
    "content" => "message here",
    "timezone" => "America/Panama",
    "delivery_time" => time_string,
    "user_id" => 1}
  end

  def send_reminder_to_one_signal(%Reminder{} = reminder) do
    time_string = reminder.time_start |> Time.to_string |> String.slice(0..4)
    params = %{"user_id" => reminder.creator_id, "timezone" => reminder.local_timezone, "delivery_time" => time_string, "title" => "Kind reminder", "content" => reminder.name}
    send_push_notification(params)
  end

  # Takes params and sends to one signal
  def send_push_notification(%{"user_id" => user_id, "timezone" => timezone, "delivery_time" => time, "title" => title, "content" => content} = args) do
    api_key = System.get_env("ONESIGNAL_API_KEY")
    default =
    %{"app_id" => "277bc59b-8037-4702-8a45-66cb485da805",
    "headings" => %{"en" => title},
    "url" => "https://pelable.com/reminders",
    "data" => %{"foo" => "bar"},
    "include_external_user_ids" => [user_id],
    "contents" => %{"en" => content},
    "delayed_option" => timezone,
    "delivery_time_of_day" => time,
    "priority" => 10} #highest priority 

    encoded_json = Jason.encode!(default)
    HTTPoison.post("https://onesignal.com/api/v1/notifications", encoded_json, [{"Content-Type", "application/json"}, {"charset", "utf-8"}, {"Authorization", "Basic " <> api_key}])
  end

  @doc """
  Deletes a reminder.

  ## Examples

      iex> delete_reminder(reminder)
      {:ok, %Reminder{}}

      iex> delete_reminder(reminder)
      {:error, %Ecto.Changeset{}}

  """
  def delete_reminder(%Reminder{} = reminder) do
    Repo.delete(reminder)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking reminder changes.

  ## Examples

      iex> change_reminder(reminder)
      %Ecto.Changeset{data: %Reminder{}}

  """
  def change_reminder(%Reminder{} = reminder, attrs \\ %{}) do
    Reminder.changeset(reminder, attrs)
  end

  alias Pelable.Habits.HabitReminder

  @doc """
  Returns the list of habit_reminder.

  ## Examples

      iex> list_habit_reminder()
      [%HabitReminder{}, ...]

  """
  def list_habit_reminder do
    Repo.all(HabitReminder)
  end

  @doc """
  Gets a single habit_reminder.

  Raises `Ecto.NoResultsError` if the Habit reminder does not exist.

  ## Examples

      iex> get_habit_reminder!(123)
      %HabitReminder{}

      iex> get_habit_reminder!(456)
      ** (Ecto.NoResultsError)

  """
  def get_habit_reminder!(id), do: Repo.get!(HabitReminder, id)

  @doc """
  Creates a habit_reminder.

  ## Examples

      iex> create_habit_reminder(%{field: value})
      {:ok, %HabitReminder{}}

      iex> create_habit_reminder(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_habit_reminder(attrs \\ %{}) do
    %HabitReminder{}
    |> HabitReminder.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a habit_reminder.

  ## Examples

      iex> update_habit_reminder(habit_reminder, %{field: new_value})
      {:ok, %HabitReminder{}}

      iex> update_habit_reminder(habit_reminder, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_habit_reminder(%HabitReminder{} = habit_reminder, attrs) do
    habit_reminder
    |> HabitReminder.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a habit_reminder.

  ## Examples

      iex> delete_habit_reminder(habit_reminder)
      {:ok, %HabitReminder{}}

      iex> delete_habit_reminder(habit_reminder)
      {:error, %Ecto.Changeset{}}

  """
  def delete_habit_reminder(%HabitReminder{} = habit_reminder) do
    Repo.delete(habit_reminder)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking habit_reminder changes.

  ## Examples

      iex> change_habit_reminder(habit_reminder)
      %Ecto.Changeset{data: %HabitReminder{}}

  """
  def change_habit_reminder(%HabitReminder{} = habit_reminder, attrs \\ %{}) do
    HabitReminder.changeset(habit_reminder, attrs)
  end
end
