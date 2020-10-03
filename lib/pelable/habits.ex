defmodule Pelable.Habits do
  @moduledoc """
  The Habits context.
  """

  import Ecto.Query, warn: false
  alias Pelable.Repo

  alias Pelable.Users.User
  alias Pelable.Habits.{Habit, Streak, HabitCompletion}
  alias Pelable.Accounts

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

  # Takes a map and a user returns a new Habit which has a new streak as well.
  # %{} -> %Habit{}
  def create_habit(%{} = params, %User{} = user) do
    params = params |> Map.put("user_id", user.id)
    {:ok, habit} = create_habit(params)
    streak_params = %{"habit_id" => habit.id}
    create_streak(streak_params)
    habit
  end

  # Converts a day & time in UTC to the equivalent day & time in another timezone
  # %NaiveDateTime{}, String -> %DateTime{}
  def convert_to_local_time(%NaiveDateTime{} = naive, local_timezone) do
    {:ok, date_time} = DateTime.from_naive(naive, "Etc/UTC")
    {:ok, local_datetime} = DateTime.shift_zone(date_time, local_timezone, Tzdata.TimeZoneDatabase)
    local_datetime
  end

  #Takes a naive date time and a time zone and turns it to a DateTime with that timezone
  # %NaiveDateTime{}, String -> %DateTime{}
  def add_timezone(%NaiveDateTime{} = naive, timezone) do
    {:ok, date_time} = DateTime.from_naive(naive, timezone, Tzdata.TimeZoneDatabase)
    date_time
  end

  #Get last habitcompletion, habit frequency and return true if habit completion has been under habit frequency
  def is_streak_active?(%Streak{} = streak, local_present_time, timezone, time_frequency = "daily") do
    habit_completion = get_last_habit_completion(streak)
    case habit_completion do
      nil ->
        streak_creation_time = convert_to_local_time(streak.created_at, timezone)
        streak_creation_time.day == local_present_time.day #Returns true if we're in the same day the streak was created

      habit_completion ->
        completion_date = habit_completion.created_at_local_datetime |> add_timezone(timezone) |> DateTime.to_date
        present_date = local_present_time |> DateTime.to_date

        Date.diff(present_date, completion_date) <= 1 # Returns true if habit completion was today or yesterday
    end

  end

  #Gets a habit and returns an active streak.
  #If the last streak is still active it returns it otherwise creates a new one.
  # %Habit{} -> %Streak{}
  def get_or_create_active_streak(%Habit{} = habit, local_present_time, timezone) do
    streak = get_last_streak(habit)
    case is_streak_active?(streak, local_present_time, timezone, habit.time_frequency) do
      true -> streak
      false -> 
        {:ok, new_streak} = create_streak(%{"habit_id" => habit.id})
        new_streak
    end
  end

  def get_last_streak(%Habit{} = habit) do
    query = 
    from s in Streak,
    where: s.habit_id == ^habit.id,
    order_by: [desc: s.id],
    limit: 1
    Repo.one(query)
  end

  def get_last_habit_completion(%Streak{} = streak) do
    query = 
    from hc in HabitCompletion,
    where: hc.streak_id == ^streak.id,
    order_by: [desc: hc.id],
    limit: 1
    Repo.one(query)
  end

  #Gets a map with a habit's uuid and a user and returns a new habit completion
  # %{}, %User{} -> %HabitCompletion{}
  def create_habit_completion(%{"habit_uuid" => uuid} = params, %User{} = user) do
    timezone = get_user_timezone(user)
    {:ok, local_present_time} = DateTime.now(timezone, Tzdata.TimeZoneDatabase)
    active_streak = get_habit_by_uuid(uuid) |> get_or_create_active_streak(local_present_time, timezone)
    
    params
    |> Map.put("streak_id", active_streak.id)
    |> Map.put("local_timezone", timezone) 
    |> Map.put("created_at_local_datetime", local_present_time)
    |> create_habit_completion
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
end
