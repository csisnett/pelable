defmodule Pelable.Repo.Migrations.CreateHabitcompletionreward do
  use Ecto.Migration

  def change do
    create table(:habit_completion_reward) do
      add :taken_at_local, :naive_datetime
      add :local_timezone, :string
      add :uuid, :uuid, null: false

      add :reward_id, references(:rewards, on_delete: :delete_all), null: false
      add :habit_completion_id, references(:habit_completion, on_delete: :delete_all), null: false

      timestamps()
    end
    create index(:habit_completion_reward, [:reward_id])
    create index(:habit_completion_reward, [:habit_completion_id])
    create unique_index(:habit_completion_reward, [:uuid])
  end
end
