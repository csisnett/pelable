defmodule Pelable.Repo.Migrations.CreateUserGoalTable do
  use Ecto.Migration

  def change do
    create table(:user_goal) do
      add :user_id, references(:users)
      add :goal_id, references(:goals)
      add :status, :string
      
      timestamps()
    end
    create unique_index(:user_goal, [:user_id, :goal_id])
  end
end
