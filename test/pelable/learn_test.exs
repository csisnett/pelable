defmodule Pelable.LearnTest do
  use Pelable.DataCase

  alias Pelable.Learn

  describe "goals" do
    alias Pelable.Learn.Goal

    @valid_attrs %{title: "some title"}
    @update_attrs %{title: "some updated title"}
    @invalid_attrs %{title: nil}

    def goal_fixture(attrs \\ %{}) do
      {:ok, goal} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Learn.create_goal()

      goal
    end

    test "list_goals/0 returns all goals" do
      goal = goal_fixture()
      assert Learn.list_goals() == [goal]
    end

    test "get_goal!/1 returns the goal with given id" do
      goal = goal_fixture()
      assert Learn.get_goal!(goal.id) == goal
    end

    test "create_goal/1 with valid data creates a goal" do
      assert {:ok, %Goal{} = goal} = Learn.create_goal(@valid_attrs)
      assert goal.title == "some title"
    end

    test "create_goal/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Learn.create_goal(@invalid_attrs)
    end

    test "update_goal/2 with valid data updates the goal" do
      goal = goal_fixture()
      assert {:ok, %Goal{} = goal} = Learn.update_goal(goal, @update_attrs)
      assert goal.title == "some updated title"
    end

    test "update_goal/2 with invalid data returns error changeset" do
      goal = goal_fixture()
      assert {:error, %Ecto.Changeset{}} = Learn.update_goal(goal, @invalid_attrs)
      assert goal == Learn.get_goal!(goal.id)
    end

    test "delete_goal/1 deletes the goal" do
      goal = goal_fixture()
      assert {:ok, %Goal{}} = Learn.delete_goal(goal)
      assert_raise Ecto.NoResultsError, fn -> Learn.get_goal!(goal.id) end
    end

    test "change_goal/1 returns a goal changeset" do
      goal = goal_fixture()
      assert %Ecto.Changeset{} = Learn.change_goal(goal)
    end
  end
end
