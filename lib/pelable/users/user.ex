defmodule Pelable.Users.User do
  use Ecto.Schema
  use Pow.Ecto.Schema

  schema "users" do
    field :username, :string
    field :nickname, :string
    field :fullname, :string
    
    pow_user_fields()

    timestamps()
  end
end
