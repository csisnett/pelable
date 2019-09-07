defmodule Pelable.ChatTest do
  use Pelable.DataCase

  alias Pelable.Chat

  describe "chatrooms" do
    alias Pelable.Chat.Chatroom

    @valid_attrs %{description: "some description", name: "some name", topic: "some topic", uuid: "some uuid"}
    @update_attrs %{description: "some updated description", name: "some updated name", topic: "some updated topic", uuid: "some updated uuid"}
    @invalid_attrs %{description: nil, name: nil, topic: nil, uuid: nil}

    def chatroom_fixture(attrs \\ %{}) do
      {:ok, chatroom} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Chat.create_chatroom()

      chatroom
    end

    test "list_chatrooms/0 returns all chatrooms" do
      chatroom = chatroom_fixture()
      assert Chat.list_chatrooms() == [chatroom]
    end

    test "get_chatroom!/1 returns the chatroom with given id" do
      chatroom = chatroom_fixture()
      assert Chat.get_chatroom!(chatroom.id) == chatroom
    end

    test "create_chatroom/1 with valid data creates a chatroom" do
      assert {:ok, %Chatroom{} = chatroom} = Chat.create_chatroom(@valid_attrs)
      assert chatroom.description == "some description"
      assert chatroom.name == "some name"
      assert chatroom.topic == "some topic"
      assert chatroom.uuid == "some uuid"
    end

    test "create_chatroom/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Chat.create_chatroom(@invalid_attrs)
    end

    test "update_chatroom/2 with valid data updates the chatroom" do
      chatroom = chatroom_fixture()
      assert {:ok, %Chatroom{} = chatroom} = Chat.update_chatroom(chatroom, @update_attrs)
      assert chatroom.description == "some updated description"
      assert chatroom.name == "some updated name"
      assert chatroom.topic == "some updated topic"
      assert chatroom.uuid == "some updated uuid"
    end

    test "update_chatroom/2 with invalid data returns error changeset" do
      chatroom = chatroom_fixture()
      assert {:error, %Ecto.Changeset{}} = Chat.update_chatroom(chatroom, @invalid_attrs)
      assert chatroom == Chat.get_chatroom!(chatroom.id)
    end

    test "delete_chatroom/1 deletes the chatroom" do
      chatroom = chatroom_fixture()
      assert {:ok, %Chatroom{}} = Chat.delete_chatroom(chatroom)
      assert_raise Ecto.NoResultsError, fn -> Chat.get_chatroom!(chatroom.id) end
    end

    test "change_chatroom/1 returns a chatroom changeset" do
      chatroom = chatroom_fixture()
      assert %Ecto.Changeset{} = Chat.change_chatroom(chatroom)
    end
  end
end
