defmodule Pelable.Repo.Migrations.CreateHabitreward do
  use Ecto.Migration

  def change do
    create table(:habit_reward) do
      add :habit_id, references(:habits, on_delete: :delete_all), null: false
      add :reward_id, references(:rewards, on_delete: :delete_all), null: false
      
      timestamps()
    end

  end
end
