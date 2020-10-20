defmodule Pelable.Repo.Migrations.CreateReminders do
  use Ecto.Migration

  def change do
    create table(:reminders) do
      add :name, :string, null: false
      add :uuid, :uuid, null: false
      add :local_timezone, :string, null: false
      add :time_start, :time, null: false
      add :date_start, :date, null: false
      add :date_end, :date
      add :repeat_on_days, {:array, :string}
      add :time_frequency, :string
      add :frequency_interval, :integer
      add :creator_id, references(:users, on_delete: :delete_all), null: false
      timestamps()
    end
    create unique_index(:reminders, [:uuid])
    create index(:reminders, [:creator_id])
  end
end
