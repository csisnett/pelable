defmodule Pelable.WorkProjectsTest do
  use Pelable.DataCase

  alias Pelable.WorkProjects


  describe "work_project_user_story" do
    alias Pelable.WorkProjects.WorkProjectUserStory

    @valid_attrs %{status: "some status"}
    @update_attrs %{status: "some updated status"}
    @invalid_attrs %{status: nil}

    def work_project_user_story_fixture(attrs \\ %{}) do
      {:ok, work_project_user_story} =
        attrs
        |> Enum.into(@valid_attrs)
        |> WorkProjects.create_work_project_user_story()

      work_project_user_story
    end

    test "list_work_project_user_story/0 returns all work_project_user_story" do
      work_project_user_story = work_project_user_story_fixture()
      assert WorkProjects.list_work_project_user_story() == [work_project_user_story]
    end

    test "get_work_project_user_story!/1 returns the work_project_user_story with given id" do
      work_project_user_story = work_project_user_story_fixture()
      assert WorkProjects.get_work_project_user_story!(work_project_user_story.id) == work_project_user_story
    end

    test "create_work_project_user_story/1 with valid data creates a work_project_user_story" do
      assert {:ok, %WorkProjectUserStory{} = work_project_user_story} = WorkProjects.create_work_project_user_story(@valid_attrs)
      assert work_project_user_story.status == "some status"
    end

    test "create_work_project_user_story/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = WorkProjects.create_work_project_user_story(@invalid_attrs)
    end

    test "update_work_project_user_story/2 with valid data updates the work_project_user_story" do
      work_project_user_story = work_project_user_story_fixture()
      assert {:ok, %WorkProjectUserStory{} = work_project_user_story} = WorkProjects.update_work_project_user_story(work_project_user_story, @update_attrs)
      assert work_project_user_story.status == "some updated status"
    end

    test "update_work_project_user_story/2 with invalid data returns error changeset" do
      work_project_user_story = work_project_user_story_fixture()
      assert {:error, %Ecto.Changeset{}} = WorkProjects.update_work_project_user_story(work_project_user_story, @invalid_attrs)
      assert work_project_user_story == WorkProjects.get_work_project_user_story!(work_project_user_story.id)
    end

    test "delete_work_project_user_story/1 deletes the work_project_user_story" do
      work_project_user_story = work_project_user_story_fixture()
      assert {:ok, %WorkProjectUserStory{}} = WorkProjects.delete_work_project_user_story(work_project_user_story)
      assert_raise Ecto.NoResultsError, fn -> WorkProjects.get_work_project_user_story!(work_project_user_story.id) end
    end

    test "change_work_project_user_story/1 returns a work_project_user_story changeset" do
      work_project_user_story = work_project_user_story_fixture()
      assert %Ecto.Changeset{} = WorkProjects.change_work_project_user_story(work_project_user_story)
    end
  end
end
