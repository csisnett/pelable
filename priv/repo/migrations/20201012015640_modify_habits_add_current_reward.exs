defmodule Pelable.Repo.Migrations.ModifyHabitsAddCurrentReward do
  use Ecto.Migration

  def change do
    alter table(:habits) do
      add :current_reward_id, references(:rewards)
    end
  end
end
