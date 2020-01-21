defmodule Pelable.Repo.Migrations.DropUserGoalTable do
  use Ecto.Migration

  def change do
    drop_if_exists table("user_goal")
  end
end
