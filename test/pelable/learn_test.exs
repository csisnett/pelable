defmodule Pelable.LearnTest do
  use Pelable.DataCase

  alias Pelable.Learn

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

  describe "posts" do
    alias Pelable.Learn.Post

    @valid_attrs %{body: "some body", uuid: "7488a646-e31f-11e4-aace-600308960662"}
    @update_attrs %{body: "some updated body",  uuid: "7488a646-e31f-11e4-aace-600308960668"}
    @invalid_attrs %{body: nil, uuid: nil}

    def post_fixture(attrs \\ %{}) do
      {:ok, post} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Learn.create_post()

      post
    end

    test "list_posts/0 returns all posts" do
      post = post_fixture()
      assert Learn.list_posts() == [post]
    end

    test "get_post!/1 returns the post with given id" do
      post = post_fixture()
      assert Learn.get_post!(post.id) == post
    end

    test "create_post/1 with valid data creates a post" do
      assert {:ok, %Post{} = post} = Learn.create_post(@valid_attrs)
      assert post.body == "some body"
      assert post.uuid == "7488a646-e31f-11e4-aace-600308960662"
    end

    test "create_post/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Learn.create_post(@invalid_attrs)
    end

    test "update_post/2 with valid data updates the post" do
      post = post_fixture()
      assert {:ok, %Post{} = post} = Learn.update_post(post, @update_attrs)
      assert post.body == "some updated body"
      assert post.uuid == "7488a646-e31f-11e4-aace-600308960668"
    end

    test "update_post/2 with invalid data returns error changeset" do
      post = post_fixture()
      assert {:error, %Ecto.Changeset{}} = Learn.update_post(post, @invalid_attrs)
      assert post == Learn.get_post!(post.id)
    end

    test "delete_post/1 deletes the post" do
      post = post_fixture()
      assert {:ok, %Post{}} = Learn.delete_post(post)
      assert_raise Ecto.NoResultsError, fn -> Learn.get_post!(post.id) end
    end

    test "change_post/1 returns a post changeset" do
      post = post_fixture()
      assert %Ecto.Changeset{} = Learn.change_post(post)
    end
  end

  describe "threads" do
    alias Pelable.Learn.Thread

    @valid_attrs %{title: "some title", type: "some type", uuid: "7488a646-e31f-11e4-aace-600308960662"}
    @update_attrs %{title: "some updated title", type: "some updated type", uuid: "7488a646-e31f-11e4-aace-600308960668"}
    @invalid_attrs %{title: nil, type: nil, uuid: nil}

    def thread_fixture(attrs \\ %{}) do
      {:ok, thread} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Learn.create_thread()

      thread
    end

    test "list_threads/0 returns all threads" do
      thread = thread_fixture()
      assert Learn.list_threads() == [thread]
    end

    test "get_thread!/1 returns the thread with given id" do
      thread = thread_fixture()
      assert Learn.get_thread!(thread.id) == thread
    end

    test "create_thread/1 with valid data creates a thread" do
      assert {:ok, %Thread{} = thread} = Learn.create_thread(@valid_attrs)
      assert thread.title == "some title"
      assert thread.type == "some type"
      assert thread.uuid == "7488a646-e31f-11e4-aace-600308960662"
    end

    test "create_thread/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Learn.create_thread(@invalid_attrs)
    end

    test "update_thread/2 with valid data updates the thread" do
      thread = thread_fixture()
      assert {:ok, %Thread{} = thread} = Learn.update_thread(thread, @update_attrs)
      assert thread.title == "some updated title"
      assert thread.type == "some updated type"
      assert thread.uuid == "7488a646-e31f-11e4-aace-600308960668"
    end

    test "update_thread/2 with invalid data returns error changeset" do
      thread = thread_fixture()
      assert {:error, %Ecto.Changeset{}} = Learn.update_thread(thread, @invalid_attrs)
      assert thread == Learn.get_thread!(thread.id)
    end

    test "delete_thread/1 deletes the thread" do
      thread = thread_fixture()
      assert {:ok, %Thread{}} = Learn.delete_thread(thread)
      assert_raise Ecto.NoResultsError, fn -> Learn.get_thread!(thread.id) end
    end

    test "change_thread/1 returns a thread changeset" do
      thread = thread_fixture()
      assert %Ecto.Changeset{} = Learn.change_thread(thread)
    end
  end

  describe "thread_posts" do
    alias Pelable.Learn.ThreadPost

    @valid_attrs %{}
    @update_attrs %{}
    @invalid_attrs %{}

    def thread_post_fixture(attrs \\ %{}) do
      {:ok, thread_post} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Learn.create_thread_post()

      thread_post
    end

    test "list_thread_posts/0 returns all thread_posts" do
      thread_post = thread_post_fixture()
      assert Learn.list_thread_posts() == [thread_post]
    end

    test "get_thread_post!/1 returns the thread_post with given id" do
      thread_post = thread_post_fixture()
      assert Learn.get_thread_post!(thread_post.id) == thread_post
    end

    test "create_thread_post/1 with valid data creates a thread_post" do
      assert {:ok, %ThreadPost{} = thread_post} = Learn.create_thread_post(@valid_attrs)
    end

    test "create_thread_post/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Learn.create_thread_post(@invalid_attrs)
    end

    test "update_thread_post/2 with valid data updates the thread_post" do
      thread_post = thread_post_fixture()
      assert {:ok, %ThreadPost{} = thread_post} = Learn.update_thread_post(thread_post, @update_attrs)
    end

    test "update_thread_post/2 with invalid data returns error changeset" do
      thread_post = thread_post_fixture()
      assert {:error, %Ecto.Changeset{}} = Learn.update_thread_post(thread_post, @invalid_attrs)
      assert thread_post == Learn.get_thread_post!(thread_post.id)
    end

    test "delete_thread_post/1 deletes the thread_post" do
      thread_post = thread_post_fixture()
      assert {:ok, %ThreadPost{}} = Learn.delete_thread_post(thread_post)
      assert_raise Ecto.NoResultsError, fn -> Learn.get_thread_post!(thread_post.id) end
    end

    test "change_thread_post/1 returns a thread_post changeset" do
      thread_post = thread_post_fixture()
      assert %Ecto.Changeset{} = Learn.change_thread_post(thread_post)
    end
  end
end
