defmodule Pelable.Chat.LastConnection do
    use Ecto.Schema
    import Ecto.Changeset
  
    alias Pelable.Users.User
    alias Pelable.Chat.{LastConnection, Chatroom}
  
    schema "last_connection" do
      belongs_to :user, User
      belongs_to :chatroom, Chatroom
      timestamps()
    end
  
    @doc false
    def changeset(last_connection, attrs) do
      last_connection
      |> cast(attrs, [:user_id, :chatroom_id, :updated_at])
      |> validate_required([:user_id, :chatroom_id])
    end
end
  