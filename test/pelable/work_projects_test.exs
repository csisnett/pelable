defmodule Pelable.WorkProjectsTest do
  use Pelable.DataCase

  alias Pelable.WorkProjects

  describe "work_project_user_story" do
    alias Pelable.WorkProjects.ProjectUserStory

    @valid_attrs %{status: "some status"}
    @update_attrs %{status: "some updated status"}
    @invalid_attrs %{status: nil}

    def project_user_story_fixture(attrs \\ %{}) do
      {:ok, project_user_story} =
        attrs
        |> Enum.into(@valid_attrs)
        |> WorkProjects.create_project_user_story()

      project_user_story
    end

    test "list_work_project_user_story/0 returns all work_project_user_story" do
      project_user_story = project_user_story_fixture()
      assert WorkProjects.list_work_project_user_story() == [project_user_story]
    end

    test "get_project_user_story!/1 returns the project_user_story with given id" do
      project_user_story = project_user_story_fixture()
      assert WorkProjects.get_project_user_story!(project_user_story.id) == project_user_story
    end

    test "create_project_user_story/1 with valid data creates a project_user_story" do
      assert {:ok, %ProjectUserStory{} = project_user_story} = WorkProjects.create_project_user_story(@valid_attrs)
      assert project_user_story.status == "some status"
    end

    test "create_project_user_story/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = WorkProjects.create_project_user_story(@invalid_attrs)
    end

    test "update_project_user_story/2 with valid data updates the project_user_story" do
      project_user_story = project_user_story_fixture()
      assert {:ok, %ProjectUserStory{} = project_user_story} = WorkProjects.update_project_user_story(project_user_story, @update_attrs)
      assert project_user_story.status == "some updated status"
    end

    test "update_project_user_story/2 with invalid data returns error changeset" do
      project_user_story = project_user_story_fixture()
      assert {:error, %Ecto.Changeset{}} = WorkProjects.update_project_user_story(project_user_story, @invalid_attrs)
      assert project_user_story == WorkProjects.get_project_user_story!(project_user_story.id)
    end

    test "delete_project_user_story/1 deletes the project_user_story" do
      project_user_story = project_user_story_fixture()
      assert {:ok, %ProjectUserStory{}} = WorkProjects.delete_project_user_story(project_user_story)
      assert_raise Ecto.NoResultsError, fn -> WorkProjects.get_project_user_story!(project_user_story.id) end
    end

    test "change_project_user_story/1 returns a project_user_story changeset" do
      project_user_story = project_user_story_fixture()
      assert %Ecto.Changeset{} = WorkProjects.change_project_user_story(project_user_story)
    end
  end
end
