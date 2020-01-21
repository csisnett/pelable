defmodule Pelable.Repo.Migrations.DropGoalsTable do
  use Ecto.Migration

  def change do
    drop_if_exists table("goals")
  end
end
