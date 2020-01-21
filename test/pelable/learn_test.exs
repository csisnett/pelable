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

  describe "tags" do
    alias Pelable.Learn.Tag

    @valid_attrs %{name: "some name"}
    @update_attrs %{name: "some updated name"}
    @invalid_attrs %{name: nil}

    def tag_fixture(attrs \\ %{}) do
      {:ok, tag} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Learn.create_tag()

      tag
    end

    test "list_tags/0 returns all tags" do
      tag = tag_fixture()
      assert Learn.list_tags() == [tag]
    end

    test "get_tag!/1 returns the tag with given id" do
      tag = tag_fixture()
      assert Learn.get_tag!(tag.id) == tag
    end

    test "create_tag/1 with valid data creates a tag" do
      assert {:ok, %Tag{} = tag} = Learn.create_tag(@valid_attrs)
      assert tag.name == "some name"
    end

    test "create_tag/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Learn.create_tag(@invalid_attrs)
    end

    test "update_tag/2 with valid data updates the tag" do
      tag = tag_fixture()
      assert {:ok, %Tag{} = tag} = Learn.update_tag(tag, @update_attrs)
      assert tag.name == "some updated name"
    end

    test "update_tag/2 with invalid data returns error changeset" do
      tag = tag_fixture()
      assert {:error, %Ecto.Changeset{}} = Learn.update_tag(tag, @invalid_attrs)
      assert tag == Learn.get_tag!(tag.id)
    end

    test "delete_tag/1 deletes the tag" do
      tag = tag_fixture()
      assert {:ok, %Tag{}} = Learn.delete_tag(tag)
      assert_raise Ecto.NoResultsError, fn -> Learn.get_tag!(tag.id) end
    end

    test "change_tag/1 returns a tag changeset" do
      tag = tag_fixture()
      assert %Ecto.Changeset{} = Learn.change_tag(tag)
    end
  end

  describe "workspaces" do
    alias Pelable.Learn.Workspace

    @valid_attrs %{name: "some name", type: "some type"}
    @update_attrs %{name: "some updated name", type: "some updated type"}
    @invalid_attrs %{name: nil, type: nil}

    def workspace_fixture(attrs \\ %{}) do
      {:ok, workspace} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Learn.create_workspace()

      workspace
    end

    test "list_workspaces/0 returns all workspaces" do
      workspace = workspace_fixture()
      assert Learn.list_workspaces() == [workspace]
    end

    test "get_workspace!/1 returns the workspace with given id" do
      workspace = workspace_fixture()
      assert Learn.get_workspace!(workspace.id) == workspace
    end

    test "create_workspace/1 with valid data creates a workspace" do
      assert {:ok, %Workspace{} = workspace} = Learn.create_workspace(@valid_attrs)
      assert workspace.name == "some name"
      assert workspace.type == "some type"
    end

    test "create_workspace/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Learn.create_workspace(@invalid_attrs)
    end

    test "update_workspace/2 with valid data updates the workspace" do
      workspace = workspace_fixture()
      assert {:ok, %Workspace{} = workspace} = Learn.update_workspace(workspace, @update_attrs)
      assert workspace.name == "some updated name"
      assert workspace.type == "some updated type"
    end

    test "update_workspace/2 with invalid data returns error changeset" do
      workspace = workspace_fixture()
      assert {:error, %Ecto.Changeset{}} = Learn.update_workspace(workspace, @invalid_attrs)
      assert workspace == Learn.get_workspace!(workspace.id)
    end

    test "delete_workspace/1 deletes the workspace" do
      workspace = workspace_fixture()
      assert {:ok, %Workspace{}} = Learn.delete_workspace(workspace)
      assert_raise Ecto.NoResultsError, fn -> Learn.get_workspace!(workspace.id) end
    end

    test "change_workspace/1 returns a workspace changeset" do
      workspace = workspace_fixture()
      assert %Ecto.Changeset{} = Learn.change_workspace(workspace)
    end
  end

  describe "workspace_member" do
    alias Pelable.Learn.WorkspaceMember

    @valid_attrs %{role: "some role"}
    @update_attrs %{role: "some updated role"}
    @invalid_attrs %{role: nil}

    def workspace_member_fixture(attrs \\ %{}) do
      {:ok, workspace_member} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Learn.create_workspace_member()

      workspace_member
    end

    test "list_workspace_member/0 returns all workspace_member" do
      workspace_member = workspace_member_fixture()
      assert Learn.list_workspace_member() == [workspace_member]
    end

    test "get_workspace_member!/1 returns the workspace_member with given id" do
      workspace_member = workspace_member_fixture()
      assert Learn.get_workspace_member!(workspace_member.id) == workspace_member
    end

    test "create_workspace_member/1 with valid data creates a workspace_member" do
      assert {:ok, %WorkspaceMember{} = workspace_member} = Learn.create_workspace_member(@valid_attrs)
      assert workspace_member.role == "some role"
    end

    test "create_workspace_member/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Learn.create_workspace_member(@invalid_attrs)
    end

    test "update_workspace_member/2 with valid data updates the workspace_member" do
      workspace_member = workspace_member_fixture()
      assert {:ok, %WorkspaceMember{} = workspace_member} = Learn.update_workspace_member(workspace_member, @update_attrs)
      assert workspace_member.role == "some updated role"
    end

    test "update_workspace_member/2 with invalid data returns error changeset" do
      workspace_member = workspace_member_fixture()
      assert {:error, %Ecto.Changeset{}} = Learn.update_workspace_member(workspace_member, @invalid_attrs)
      assert workspace_member == Learn.get_workspace_member!(workspace_member.id)
    end

    test "delete_workspace_member/1 deletes the workspace_member" do
      workspace_member = workspace_member_fixture()
      assert {:ok, %WorkspaceMember{}} = Learn.delete_workspace_member(workspace_member)
      assert_raise Ecto.NoResultsError, fn -> Learn.get_workspace_member!(workspace_member.id) end
    end

    test "change_workspace_member/1 returns a workspace_member changeset" do
      workspace_member = workspace_member_fixture()
      assert %Ecto.Changeset{} = Learn.change_workspace_member(workspace_member)
    end
  end
end
