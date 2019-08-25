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
end
