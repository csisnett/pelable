defmodule Pelable.Learn.Goal do
  use Ecto.Schema
  import Ecto.Changeset

  alias Pelable.Users.User

  schema "goals" do
    field :title, :string

    many_to_many :users, User, join_through: "user_goal"
    timestamps()
  end

  @doc false
  def changeset(goal, attrs) do
    goal
    |> cast(attrs, [:title])
    |> validate_required([:title])
  end
end
