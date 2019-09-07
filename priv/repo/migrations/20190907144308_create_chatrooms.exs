defmodule Pelable.Repo.Migrations.CreateChatrooms do
  use Ecto.Migration

  def change do
    create table(:chatrooms) do
      add :uuid, :string
      add :description, :text
      add :name, :string
      add :topic, :string
      add :creator_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create unique_index(:chatrooms, [:uuid])
    create index(:chatrooms, [:creator_id])
  end
end
