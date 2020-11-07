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

  describe "tasks" do
    alias Pelable.Learn.Task

    @valid_attrs %{name: "some name", status: "some status"}
    @update_attrs %{name: "some updated name", status: "some updated status"}
    @invalid_attrs %{name: nil, status: nil}

    def task_fixture(attrs \\ %{}) do
      {:ok, task} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Learn.create_task()

      task
    end

    test "list_tasks/0 returns all tasks" do
      task = task_fixture()
      assert Learn.list_tasks() == [task]
    end

    test "get_task!/1 returns the task with given id" do
      task = task_fixture()
      assert Learn.get_task!(task.id) == task
    end

    test "create_task/1 with valid data creates a task" do
      assert {:ok, %Task{} = task} = Learn.create_task(@valid_attrs)
      assert task.name == "some name"
      assert task.status == "some status"
    end

    test "create_task/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Learn.create_task(@invalid_attrs)
    end

    test "update_task/2 with valid data updates the task" do
      task = task_fixture()
      assert {:ok, %Task{} = task} = Learn.update_task(task, @update_attrs)
      assert task.name == "some updated name"
      assert task.status == "some updated status"
    end

    test "update_task/2 with invalid data returns error changeset" do
      task = task_fixture()
      assert {:error, %Ecto.Changeset{}} = Learn.update_task(task, @invalid_attrs)
      assert task == Learn.get_task!(task.id)
    end

    test "delete_task/1 deletes the task" do
      task = task_fixture()
      assert {:ok, %Task{}} = Learn.delete_task(task)
      assert_raise Ecto.NoResultsError, fn -> Learn.get_task!(task.id) end
    end

    test "change_task/1 returns a task changeset" do
      task = task_fixture()
      assert %Ecto.Changeset{} = Learn.change_task(task)
    end
  end

  describe "resources" do
    alias Pelable.Learn.Resource

    @valid_attrs %{url: "some url"}
    @update_attrs %{url: "some updated url"}
    @invalid_attrs %{url: nil}

    def resource_fixture(attrs \\ %{}) do
      {:ok, resource} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Learn.create_resource()

      resource
    end

    test "list_resources/0 returns all resources" do
      resource = resource_fixture()
      assert Learn.list_resources() == [resource]
    end

    test "get_resource!/1 returns the resource with given id" do
      resource = resource_fixture()
      assert Learn.get_resource!(resource.id) == resource
    end

    test "create_resource/1 with valid data creates a resource" do
      assert {:ok, %Resource{} = resource} = Learn.create_resource(@valid_attrs)
      assert resource.url == "some url"
    end

    test "create_resource/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Learn.create_resource(@invalid_attrs)
    end

    test "update_resource/2 with valid data updates the resource" do
      resource = resource_fixture()
      assert {:ok, %Resource{} = resource} = Learn.update_resource(resource, @update_attrs)
      assert resource.url == "some updated url"
    end

    test "update_resource/2 with invalid data returns error changeset" do
      resource = resource_fixture()
      assert {:error, %Ecto.Changeset{}} = Learn.update_resource(resource, @invalid_attrs)
      assert resource == Learn.get_resource!(resource.id)
    end

    test "delete_resource/1 deletes the resource" do
      resource = resource_fixture()
      assert {:ok, %Resource{}} = Learn.delete_resource(resource)
      assert_raise Ecto.NoResultsError, fn -> Learn.get_resource!(resource.id) end
    end

    test "change_resource/1 returns a resource changeset" do
      resource = resource_fixture()
      assert %Ecto.Changeset{} = Learn.change_resource(resource)
    end
  end
end
