defmodule Pelable.Repo.Migrations.DropHabitRewardTable do
  use Ecto.Migration

  def change do
    drop table("habit_reward")
  end
end
