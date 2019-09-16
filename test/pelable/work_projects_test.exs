defmodule Pelable.WorkProjectsTest do
  use Pelable.DataCase

  alias Pelable.WorkProjects


  describe "work_project_user_story" do
    alias Pelable.WorkProjects

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

    test "change_work_project_user_story/1 returns a work_project_user_story changeset" do
      work_project_user_story = work_project_user_story_fixture()
      assert %Ecto.Changeset{} = WorkProjects.change_work_project_user_story(work_project_user_story)
    end
  end
end
