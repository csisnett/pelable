defmodule Pelable.Repo.Migrations.CreateRewards do
  use Ecto.Migration

  def change do
    create table(:rewards) do
      add :name, :string, null: false
      add :description, :string
      add :archived?, :boolean, default: false, null: false
      add :slug, :string, null: false
      add :uuid, :uuid, null: false
      add :creator_id, references(:users, on_delete: :delete_all), null: false

      timestamps()
    end

    create index(:rewards, [:creator_id])
    create unique_index(:rewards, [:uuid])
  end
end
