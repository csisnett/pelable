defmodule Pelable.Habits do
  @moduledoc """
  The Habits context.
  """

  import Ecto.Query, warn: false
  alias Pelable.Repo

  alias Pelable.Habits.Habit

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
