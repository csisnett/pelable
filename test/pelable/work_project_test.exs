defmodule Pelable.WorkProjectTest do
  use Pelable.DataCase

  alias Pelable.WorkProject

  describe "project_versions" do
    alias Pelable.WorkProject.ProjectVersion

    @valid_attrs %{description: "some description", name: "some name", public_status: "some public_status"}
    @update_attrs %{description: "some updated description", name: "some updated name", public_status: "some updated public_status"}
    @invalid_attrs %{description: nil, name: nil, public_status: nil}

    def project_version_fixture(attrs \\ %{}) do
      {:ok, project_version} =
        attrs
        |> Enum.into(@valid_attrs)
        |> WorkProject.create_project_version()

      project_version
    end

    test "list_project_versions/0 returns all project_versions" do
      project_version = project_version_fixture()
      assert WorkProject.list_project_versions() == [project_version]
    end

    test "get_project_version!/1 returns the project_version with given id" do
      project_version = project_version_fixture()
      assert WorkProject.get_project_version!(project_version.id) == project_version
    end

    test "create_project_version/1 with valid data creates a project_version" do
      assert {:ok, %ProjectVersion{} = project_version} = WorkProject.create_project_version(@valid_attrs)
      assert project_version.description == "some description"
      assert project_version.name == "some name"
      assert project_version.public_status == "some public_status"
    end

    test "create_project_version/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = WorkProject.create_project_version(@invalid_attrs)
    end

    test "update_project_version/2 with valid data updates the project_version" do
      project_version = project_version_fixture()
      assert {:ok, %ProjectVersion{} = project_version} = WorkProject.update_project_version(project_version, @update_attrs)
      assert project_version.description == "some updated description"
      assert project_version.name == "some updated name"
      assert project_version.public_status == "some updated public_status"
    end

    test "update_project_version/2 with invalid data returns error changeset" do
      project_version = project_version_fixture()
      assert {:error, %Ecto.Changeset{}} = WorkProject.update_project_version(project_version, @invalid_attrs)
      assert project_version == WorkProject.get_project_version!(project_version.id)
    end

    test "delete_project_version/1 deletes the project_version" do
      project_version = project_version_fixture()
      assert {:ok, %ProjectVersion{}} = WorkProject.delete_project_version(project_version)
      assert_raise Ecto.NoResultsError, fn -> WorkProject.get_project_version!(project_version.id) end
    end

    test "change_project_version/1 returns a project_version changeset" do
      project_version = project_version_fixture()
      assert %Ecto.Changeset{} = WorkProject.change_project_version(project_version)
    end
  end

  describe "user_stories" do
    alias Pelable.WorkProject.UserStory

    @valid_attrs %{body: "some body"}
    @update_attrs %{body: "some updated body"}
    @invalid_attrs %{body: nil}

    def user_story_fixture(attrs \\ %{}) do
      {:ok, user_story} =
        attrs
        |> Enum.into(@valid_attrs)
        |> WorkProject.create_user_story()

      user_story
    end

    test "list_user_stories/0 returns all user_stories" do
      user_story = user_story_fixture()
      assert WorkProject.list_user_stories() == [user_story]
    end

    test "get_user_story!/1 returns the user_story with given id" do
      user_story = user_story_fixture()
      assert WorkProject.get_user_story!(user_story.id) == user_story
    end

    test "create_user_story/1 with valid data creates a user_story" do
      assert {:ok, %UserStory{} = user_story} = WorkProject.create_user_story(@valid_attrs)
      assert user_story.body == "some body"
    end

    test "create_user_story/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = WorkProject.create_user_story(@invalid_attrs)
    end

    test "update_user_story/2 with valid data updates the user_story" do
      user_story = user_story_fixture()
      assert {:ok, %UserStory{} = user_story} = WorkProject.update_user_story(user_story, @update_attrs)
      assert user_story.body == "some updated body"
    end

    test "update_user_story/2 with invalid data returns error changeset" do
      user_story = user_story_fixture()
      assert {:error, %Ecto.Changeset{}} = WorkProject.update_user_story(user_story, @invalid_attrs)
      assert user_story == WorkProject.get_user_story!(user_story.id)
    end

    test "delete_user_story/1 deletes the user_story" do
      user_story = user_story_fixture()
      assert {:ok, %UserStory{}} = WorkProject.delete_user_story(user_story)
      assert_raise Ecto.NoResultsError, fn -> WorkProject.get_user_story!(user_story.id) end
    end

    test "change_user_story/1 returns a user_story changeset" do
      user_story = user_story_fixture()
      assert %Ecto.Changeset{} = WorkProject.change_user_story(user_story)
    end
  end
end
