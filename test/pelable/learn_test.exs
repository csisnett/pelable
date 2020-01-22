defmodule Pelable.LearnTest do
  use Pelable.DataCase

  alias Pelable.Learn

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

  describe "projects" do
    alias Pelable.Learn.Project

    @valid_attrs %{description: "some description", name: "some name", uuid: "7488a646-e31f-11e4-aace-600308960662"}
    @update_attrs %{description: "some updated description", name: "some updated name", uuid: "7488a646-e31f-11e4-aace-600308960668"}
    @invalid_attrs %{description: nil, name: nil, uuid: nil}

    def project_fixture(attrs \\ %{}) do
      {:ok, project} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Learn.create_project()

      project
    end

    test "list_projects/0 returns all projects" do
      project = project_fixture()
      assert Learn.list_projects() == [project]
    end

    test "get_project!/1 returns the project with given id" do
      project = project_fixture()
      assert Learn.get_project!(project.id) == project
    end

    test "create_project/1 with valid data creates a project" do
      assert {:ok, %Project{} = project} = Learn.create_project(@valid_attrs)
      assert project.description == "some description"
      assert project.name == "some name"
      assert project.uuid == "7488a646-e31f-11e4-aace-600308960662"
    end

    test "create_project/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Learn.create_project(@invalid_attrs)
    end

    test "update_project/2 with valid data updates the project" do
      project = project_fixture()
      assert {:ok, %Project{} = project} = Learn.update_project(project, @update_attrs)
      assert project.description == "some updated description"
      assert project.name == "some updated name"
      assert project.uuid == "7488a646-e31f-11e4-aace-600308960668"
    end

    test "update_project/2 with invalid data returns error changeset" do
      project = project_fixture()
      assert {:error, %Ecto.Changeset{}} = Learn.update_project(project, @invalid_attrs)
      assert project == Learn.get_project!(project.id)
    end

    test "delete_project/1 deletes the project" do
      project = project_fixture()
      assert {:ok, %Project{}} = Learn.delete_project(project)
      assert_raise Ecto.NoResultsError, fn -> Learn.get_project!(project.id) end
    end

    test "change_project/1 returns a project changeset" do
      project = project_fixture()
      assert %Ecto.Changeset{} = Learn.change_project(project)
    end
  end

  describe "sections" do
    alias Pelable.Learn.Section

    @valid_attrs %{name: "some name", slug: "some slug", uuid: "7488a646-e31f-11e4-aace-600308960662"}
    @update_attrs %{name: "some updated name", slug: "some updated slug", uuid: "7488a646-e31f-11e4-aace-600308960668"}
    @invalid_attrs %{name: nil, slug: nil, uuid: nil}

    def section_fixture(attrs \\ %{}) do
      {:ok, section} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Learn.create_section()

      section
    end

    test "list_sections/0 returns all sections" do
      section = section_fixture()
      assert Learn.list_sections() == [section]
    end

    test "get_section!/1 returns the section with given id" do
      section = section_fixture()
      assert Learn.get_section!(section.id) == section
    end

    test "create_section/1 with valid data creates a section" do
      assert {:ok, %Section{} = section} = Learn.create_section(@valid_attrs)
      assert section.name == "some name"
      assert section.slug == "some slug"
      assert section.uuid == "7488a646-e31f-11e4-aace-600308960662"
    end

    test "create_section/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Learn.create_section(@invalid_attrs)
    end

    test "update_section/2 with valid data updates the section" do
      section = section_fixture()
      assert {:ok, %Section{} = section} = Learn.update_section(section, @update_attrs)
      assert section.name == "some updated name"
      assert section.slug == "some updated slug"
      assert section.uuid == "7488a646-e31f-11e4-aace-600308960668"
    end

    test "update_section/2 with invalid data returns error changeset" do
      section = section_fixture()
      assert {:error, %Ecto.Changeset{}} = Learn.update_section(section, @invalid_attrs)
      assert section == Learn.get_section!(section.id)
    end

    test "delete_section/1 deletes the section" do
      section = section_fixture()
      assert {:ok, %Section{}} = Learn.delete_section(section)
      assert_raise Ecto.NoResultsError, fn -> Learn.get_section!(section.id) end
    end

    test "change_section/1 returns a section changeset" do
      section = section_fixture()
      assert %Ecto.Changeset{} = Learn.change_section(section)
    end
  end
end
