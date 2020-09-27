defmodule Pelable.Repo.Migrations.CreateSettings do
  use Ecto.Migration

  def change do
    create table(:settings) do
      add :key, :string
      add :value, :string

      add :user_id, references(:users, on_delete: :delete_all), null: false
      timestamps()
    end
    create index(:settings, [:user_id])
    create unique_index(:settings, [:user_id, :key])
  end
end
