defmodule Pelable.Chat.LastEmail do
    use Ecto.Schema
    import Ecto.Changeset
  
    alias Pelable.Users.User
    alias Pelable.Chat.{LastConnection, Chatroom}
  
    #saves the last time we sent a messages notification to this user
    schema "last_notification_email" do
      belongs_to :user, User
      timestamps()
    end
  
    @doc false
    def changeset(last_email, attrs) do
      last_email
      |> cast(attrs, [:user_id, :updated_at])
      |> validate_required([:user_id])
    end
end
  