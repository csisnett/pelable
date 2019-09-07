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

  describe "messages" do
    alias Pelable.Chat.Message

    @valid_attrs %{body: "some body", status: "some status", uuid: "some uuid"}
    @update_attrs %{body: "some updated body", status: "some updated status", uuid: "some updated uuid"}
    @invalid_attrs %{body: nil, status: nil, uuid: nil}

    def message_fixture(attrs \\ %{}) do
      {:ok, message} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Chat.create_message()

      message
    end

    test "list_messages/0 returns all messages" do
      message = message_fixture()
      assert Chat.list_messages() == [message]
    end

    test "get_message!/1 returns the message with given id" do
      message = message_fixture()
      assert Chat.get_message!(message.id) == message
    end

    test "create_message/1 with valid data creates a message" do
      assert {:ok, %Message{} = message} = Chat.create_message(@valid_attrs)
      assert message.body == "some body"
      assert message.status == "some status"
      assert message.uuid == "some uuid"
    end

    test "create_message/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Chat.create_message(@invalid_attrs)
    end

    test "update_message/2 with valid data updates the message" do
      message = message_fixture()
      assert {:ok, %Message{} = message} = Chat.update_message(message, @update_attrs)
      assert message.body == "some updated body"
      assert message.status == "some updated status"
      assert message.uuid == "some updated uuid"
    end

    test "update_message/2 with invalid data returns error changeset" do
      message = message_fixture()
      assert {:error, %Ecto.Changeset{}} = Chat.update_message(message, @invalid_attrs)
      assert message == Chat.get_message!(message.id)
    end

    test "delete_message/1 deletes the message" do
      message = message_fixture()
      assert {:ok, %Message{}} = Chat.delete_message(message)
      assert_raise Ecto.NoResultsError, fn -> Chat.get_message!(message.id) end
    end

    test "change_message/1 returns a message changeset" do
      message = message_fixture()
      assert %Ecto.Changeset{} = Chat.change_message(message)
    end
  end
end
