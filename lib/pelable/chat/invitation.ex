defmodule Pelable.Chat.Invitation do
    use Ecto.Schema
    import Ecto.Changeset
  
    alias Pelable.Users.User
    alias Pelable.Chat.Chatroom

    schema "chatroom_invitation" do
        belongs_to :chatroom, Chatroom
        belongs_to :user,  User
    
  end

end