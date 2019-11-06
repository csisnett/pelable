defmodule Pelable.Repo.Migrations.AddLastEmailTable do
  use Ecto.Migration

  def change do
    create table(:last_notification_email) do
      add :user_id, references(:users)
      timestamps()
    end
    create unique_index(:last_notification_email, [:user_id])
  end
end
