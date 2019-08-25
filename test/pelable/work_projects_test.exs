defmodule Pelable.WorkProjectsTest do
  use Pelable.DataCase

  alias Pelable.WorkProjects

  describe "work_projects" do
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
end
