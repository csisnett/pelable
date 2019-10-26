defmodule Pelable.Repo.Migrations.AddMentionsTable do
  use Ecto.Migration

  def change do
    create table(:message_mention) do
      add :user_id, references(:users)
      add :message_id, references(:messages)
    end
    create unique_index(:message_mention, [:user_id, :message_id])
  end
end
