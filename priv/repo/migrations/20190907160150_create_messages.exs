defmodule Pelable.Repo.Migrations.CreateMessages do
  use Ecto.Migration

  def change do
    create table(:messages) do
      add :body, :text, null: false
      add :uuid, :uuid, null: false
      add :sender_id, references(:users, on_delete: :nothing), null: false
      add :chatroom_id, references(:chatrooms, on_delete: :delete_all), null: false

      timestamps()
    end
    create unique_index(:messages, [:uuid])
    create index(:messages, [:sender_id])
    create index(:messages, [:chatroom_id])
  end
end
