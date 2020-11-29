defmodule Pelable.Repo.Migrations.CreateStreakSaver do
  use Ecto.Migration

  def change do
    create table(:streak_saver) do
      add :start_date, :date
      add :end_date, :date
      add :creator_id, references(:users, on_delete: :delete_all), null: false
      add :streak_id, references(:streaks, on_delete: :delete_all), null: false
      timestamps()
    end

  end
end
