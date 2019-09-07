defmodule Pelable.Repo.Migrations.CreateChatrooms do
  use Ecto.Migration

  def change do
    create table(:chatrooms) do
      add :uuid, :string, null: false
      add :description, :text
      add :name, :string, null: false
      add :subject, :string
      add :creator_id, references(:users, on_delete: :nothing), null: false

      timestamps()
    end

    create unique_index(:chatrooms, [:uuid])
    create index(:chatrooms, [:creator_id])
  end
end
