defmodule Pelable.HabitsTest do
  use Pelable.DataCase

  alias Pelable.Habits

  describe "habits" do
    alias Pelable.Habits.Habit

    @valid_attrs %{archived?: true, name: "some name", time_frequency: "some time_frequency"}
    @update_attrs %{archived?: false, name: "some updated name", time_frequency: "some updated time_frequency"}
    @invalid_attrs %{archived?: nil, name: nil, time_frequency: nil}

    def habit_fixture(attrs \\ %{}) do
      {:ok, habit} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Habits.create_habit()

      habit
    end

    test "list_habits/0 returns all habits" do
      habit = habit_fixture()
      assert Habits.list_habits() == [habit]
    end

    test "get_habit!/1 returns the habit with given id" do
      habit = habit_fixture()
      assert Habits.get_habit!(habit.id) == habit
    end

    test "create_habit/1 with valid data creates a habit" do
      assert {:ok, %Habit{} = habit} = Habits.create_habit(@valid_attrs)
      assert habit.archived? == true
      assert habit.name == "some name"
      assert habit.time_frequency == "some time_frequency"
    end

    test "create_habit/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Habits.create_habit(@invalid_attrs)
    end

    test "update_habit/2 with valid data updates the habit" do
      habit = habit_fixture()
      assert {:ok, %Habit{} = habit} = Habits.update_habit(habit, @update_attrs)
      assert habit.archived? == false
      assert habit.name == "some updated name"
      assert habit.time_frequency == "some updated time_frequency"
    end

    test "update_habit/2 with invalid data returns error changeset" do
      habit = habit_fixture()
      assert {:error, %Ecto.Changeset{}} = Habits.update_habit(habit, @invalid_attrs)
      assert habit == Habits.get_habit!(habit.id)
    end

    test "delete_habit/1 deletes the habit" do
      habit = habit_fixture()
      assert {:ok, %Habit{}} = Habits.delete_habit(habit)
      assert_raise Ecto.NoResultsError, fn -> Habits.get_habit!(habit.id) end
    end

    test "change_habit/1 returns a habit changeset" do
      habit = habit_fixture()
      assert %Ecto.Changeset{} = Habits.change_habit(habit)
    end
  end

  describe "streaks" do
    alias Pelable.Habits.Streak

    @valid_attrs %{habit: "some habit"}
    @update_attrs %{habit: "some updated habit"}
    @invalid_attrs %{habit: nil}

    def streak_fixture(attrs \\ %{}) do
      {:ok, streak} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Habits.create_streak()

      streak
    end

    test "list_streaks/0 returns all streaks" do
      streak = streak_fixture()
      assert Habits.list_streaks() == [streak]
    end

    test "get_streak!/1 returns the streak with given id" do
      streak = streak_fixture()
      assert Habits.get_streak!(streak.id) == streak
    end

    test "create_streak/1 with valid data creates a streak" do
      assert {:ok, %Streak{} = streak} = Habits.create_streak(@valid_attrs)
      assert streak.habit == "some habit"
    end

    test "create_streak/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Habits.create_streak(@invalid_attrs)
    end

    test "update_streak/2 with valid data updates the streak" do
      streak = streak_fixture()
      assert {:ok, %Streak{} = streak} = Habits.update_streak(streak, @update_attrs)
      assert streak.habit == "some updated habit"
    end

    test "update_streak/2 with invalid data returns error changeset" do
      streak = streak_fixture()
      assert {:error, %Ecto.Changeset{}} = Habits.update_streak(streak, @invalid_attrs)
      assert streak == Habits.get_streak!(streak.id)
    end

    test "delete_streak/1 deletes the streak" do
      streak = streak_fixture()
      assert {:ok, %Streak{}} = Habits.delete_streak(streak)
      assert_raise Ecto.NoResultsError, fn -> Habits.get_streak!(streak.id) end
    end

    test "change_streak/1 returns a streak changeset" do
      streak = streak_fixture()
      assert %Ecto.Changeset{} = Habits.change_streak(streak)
    end
  end

  describe "habitcompletion" do
    alias Pelable.Habits.HabitCompletion

    @valid_attrs %{local_datetime: ~N[2010-04-17 14:00:00]}
    @update_attrs %{local_datetime: ~N[2011-05-18 15:01:01]}
    @invalid_attrs %{local_datetime: nil}

    def habit_completion_fixture(attrs \\ %{}) do
      {:ok, habit_completion} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Habits.create_habit_completion()

      habit_completion
    end

    test "list_habitcompletion/0 returns all habitcompletion" do
      habit_completion = habit_completion_fixture()
      assert Habits.list_habitcompletion() == [habit_completion]
    end

    test "get_habit_completion!/1 returns the habit_completion with given id" do
      habit_completion = habit_completion_fixture()
      assert Habits.get_habit_completion!(habit_completion.id) == habit_completion
    end

    test "create_habit_completion/1 with valid data creates a habit_completion" do
      assert {:ok, %HabitCompletion{} = habit_completion} = Habits.create_habit_completion(@valid_attrs)
      assert habit_completion.local_datetime == ~N[2010-04-17 14:00:00]
    end

    test "create_habit_completion/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Habits.create_habit_completion(@invalid_attrs)
    end

    test "update_habit_completion/2 with valid data updates the habit_completion" do
      habit_completion = habit_completion_fixture()
      assert {:ok, %HabitCompletion{} = habit_completion} = Habits.update_habit_completion(habit_completion, @update_attrs)
      assert habit_completion.local_datetime == ~N[2011-05-18 15:01:01]
    end

    test "update_habit_completion/2 with invalid data returns error changeset" do
      habit_completion = habit_completion_fixture()
      assert {:error, %Ecto.Changeset{}} = Habits.update_habit_completion(habit_completion, @invalid_attrs)
      assert habit_completion == Habits.get_habit_completion!(habit_completion.id)
    end

    test "delete_habit_completion/1 deletes the habit_completion" do
      habit_completion = habit_completion_fixture()
      assert {:ok, %HabitCompletion{}} = Habits.delete_habit_completion(habit_completion)
      assert_raise Ecto.NoResultsError, fn -> Habits.get_habit_completion!(habit_completion.id) end
    end

    test "change_habit_completion/1 returns a habit_completion changeset" do
      habit_completion = habit_completion_fixture()
      assert %Ecto.Changeset{} = Habits.change_habit_completion(habit_completion)
    end
  end
end
