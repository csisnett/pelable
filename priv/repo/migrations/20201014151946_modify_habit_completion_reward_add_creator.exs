defmodule Pelable.Repo.Migrations.ModifyHabitCompletionRewardAddCreator do
  use Ecto.Migration

  def change do
    alter table(:habit_completion_reward) do
      add :creator_id, references(:users, on_delete: :delete_all), null: false
    end
    create index(:habit_completion_reward, [:creator_id])
  end
end
