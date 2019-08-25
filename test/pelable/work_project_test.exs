defmodule Pelable.WorkProjectTest do
  use Pelable.DataCase

  alias Pelable.WorkProjects

  describe "work_project" do
  alias Pelable.WorkProjects.WorkProject

    @valid_attrs %{description: "some description", end_date: "2010-04-17T14:00:00Z", public_status: "some public_status", repo_url: "some repo_url", start_date: "2010-04-17T14:00:00Z", work_status: "some work_status"}
    @update_attrs %{description: "some updated description", end_date: "2011-05-18T15:01:01Z", public_status: "some updated public_status", repo_url: "some updated repo_url", start_date: "2011-05-18T15:01:01Z", work_status: "some updated work_status"}
    @invalid_attrs %{description: nil, end_date: nil, public_status: nil, repo_url: nil, start_date: nil, work_status: nil}

    def work_project_fixture(attrs \\ %{}) do
      {:ok, work_project} =
        attrs
        |> Enum.into(@valid_attrs)
        |> WorkProjects.create_work_project()

      work_project
    end

    test "list_work_projects/0 returns all work_projects" do
      work_project = work_project_fixture()
      assert WorkProjects.list_work_projects() == [work_project]
    end

    test "get_work_project!/1 returns the work_project with given id" do
      work_project = work_project_fixture()
      assert WorkProjects.get_work_project!(work_project.id) == work_project
    end

    test "create_work_project/1 with valid data creates a work_project" do
      assert {:ok, %WorkProject{} = work_project} = WorkProjects.create_work_project(@valid_attrs)
      assert work_project.description == "some description"
      assert work_project.end_date == DateTime.from_naive!(~N[2010-04-17T14:00:00Z], "Etc/UTC")
      assert work_project.public_status == "some public_status"
      assert work_project.repo_url == "some repo_url"
      assert work_project.start_date == DateTime.from_naive!(~N[2010-04-17T14:00:00Z], "Etc/UTC")
      assert work_project.work_status == "some work_status"
    end

    test "create_work_project/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = WorkProjects.create_work_project(@invalid_attrs)
    end

    test "update_work_project/2 with valid data updates the work_project" do
      work_project = work_project_fixture()
      assert {:ok, %WorkProject{} = work_project} = WorkProjects.update_work_project(work_project, @update_attrs)
      assert work_project.description == "some updated description"
      assert work_project.end_date == DateTime.from_naive!(~N[2011-05-18T15:01:01Z], "Etc/UTC")
      assert work_project.public_status == "some updated public_status"
      assert work_project.repo_url == "some updated repo_url"
      assert work_project.start_date == DateTime.from_naive!(~N[2011-05-18T15:01:01Z], "Etc/UTC")
      assert work_project.work_status == "some updated work_status"
    end

    test "update_work_project/2 with invalid data returns error changeset" do
      work_project = work_project_fixture()
      assert {:error, %Ecto.Changeset{}} = WorkProjects.update_work_project(work_project, @invalid_attrs)
      assert work_project == WorkProjects.get_work_project!(work_project.id)
    end

    test "delete_work_project/1 deletes the work_project" do
      work_project = work_project_fixture()
      assert {:ok, %WorkProject{}} = WorkProjects.delete_work_project(work_project)
      assert_raise Ecto.NoResultsError, fn -> WorkProjects.get_work_project!(work_project.id) end
    end

    test "change_work_project/1 returns a work_project changeset" do
      work_project = work_project_fixture()
      assert %Ecto.Changeset{} = WorkProjects.change_work_project(work_project)
    end
  end

  describe "project_versions" do
    alias Pelable.WorkProjects.ProjectVersion

    @valid_attrs %{description: "some description", name: "some name", public_status: "some public_status"}
    @update_attrs %{description: "some updated description", name: "some updated name", public_status: "some updated public_status"}
    @invalid_attrs %{description: nil, name: nil, public_status: nil}

    def project_version_fixture(attrs \\ %{}) do
      {:ok, project_version} =
        attrs
        |> Enum.into(@valid_attrs)
        |> WorkProjects.create_project_version()

      project_version
    end

    test "list_project_versions/0 returns all project_versions" do
      project_version = project_version_fixture()
      assert WorkProjects.list_project_versions() == [project_version]
    end

    test "get_project_version!/1 returns the project_version with given id" do
      project_version = project_version_fixture()
      assert WorkProjects.get_project_version!(project_version.id) == project_version
    end

    test "create_project_version/1 with valid data creates a project_version" do
      assert {:ok, %ProjectVersion{} = project_version} = WorkProjects.create_project_version(@valid_attrs)
      assert project_version.description == "some description"
      assert project_version.name == "some name"
      assert project_version.public_status == "some public_status"
    end

    test "create_project_version/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = WorkProjects.create_project_version(@invalid_attrs)
    end

    test "update_project_version/2 with valid data updates the project_version" do
      project_version = project_version_fixture()
      assert {:ok, %ProjectVersion{} = project_version} = WorkProjects.update_project_version(project_version, @update_attrs)
      assert project_version.description == "some updated description"
      assert project_version.name == "some updated name"
      assert project_version.public_status == "some updated public_status"
    end

    test "update_project_version/2 with invalid data returns error changeset" do
      project_version = project_version_fixture()
      assert {:error, %Ecto.Changeset{}} = WorkProjects.update_project_version(project_version, @invalid_attrs)
      assert project_version == WorkProjects.get_project_version!(project_version.id)
    end

    test "delete_project_version/1 deletes the project_version" do
      project_version = project_version_fixture()
      assert {:ok, %ProjectVersion{}} = WorkProjects.delete_project_version(project_version)
      assert_raise Ecto.NoResultsError, fn -> WorkProjects.get_project_version!(project_version.id) end
    end

    test "change_project_version/1 returns a project_version changeset" do
      project_version = project_version_fixture()
      assert %Ecto.Changeset{} = WorkProjects.change_project_version(project_version)
    end
  end

  describe "user_stories" do
    alias Pelable.WorkProjects.UserStory

    @valid_attrs %{body: "some body"}
    @update_attrs %{body: "some updated body"}
    @invalid_attrs %{body: nil}

    def user_story_fixture(attrs \\ %{}) do
      {:ok, user_story} =
        attrs
        |> Enum.into(@valid_attrs)
        |> WorkProjects.create_user_story()

      user_story
    end

    test "list_user_stories/0 returns all user_stories" do
      user_story = user_story_fixture()
      assert WorkProjects.list_user_stories() == [user_story]
    end

    test "get_user_story!/1 returns the user_story with given id" do
      user_story = user_story_fixture()
      assert WorkProjects.get_user_story!(user_story.id) == user_story
    end

    test "create_user_story/1 with valid data creates a user_story" do
      assert {:ok, %UserStory{} = user_story} = WorkProjects.create_user_story(@valid_attrs)
      assert user_story.body == "some body"
    end

    test "create_user_story/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = WorkProjects.create_user_story(@invalid_attrs)
    end

    test "update_user_story/2 with valid data updates the user_story" do
      user_story = user_story_fixture()
      assert {:ok, %UserStory{} = user_story} = WorkProjects.update_user_story(user_story, @update_attrs)
      assert user_story.body == "some updated body"
    end

    test "update_user_story/2 with invalid data returns error changeset" do
      user_story = user_story_fixture()
      assert {:error, %Ecto.Changeset{}} = WorkProjects.update_user_story(user_story, @invalid_attrs)
      assert user_story == WorkProjects.get_user_story!(user_story.id)
    end

    test "delete_user_story/1 deletes the user_story" do
      user_story = user_story_fixture()
      assert {:ok, %UserStory{}} = WorkProjects.delete_user_story(user_story)
      assert_raise Ecto.NoResultsError, fn -> WorkProjects.get_user_story!(user_story.id) end
    end

    test "change_user_story/1 returns a user_story changeset" do
      user_story = user_story_fixture()
      assert %Ecto.Changeset{} = WorkProjects.change_user_story(user_story)
    end
  end
end
