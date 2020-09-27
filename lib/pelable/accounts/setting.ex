defmodule Pelable.Accounts.Setting do
  use Ecto.Schema
  import Ecto.Changeset
  alias Pelable.Users.User

  schema "settings" do
    field :key, :string
    field :value, :string

    belongs_to :user, User
    timestamps()
  end

  @doc false
  def changeset(settings, attrs) do
    settings
    |> cast(attrs, [:key, :value, :user_id])
    |> validate_required([:key, :value, :user_id])
    |> foreign_key_constraint(:user_id)
  end
end
