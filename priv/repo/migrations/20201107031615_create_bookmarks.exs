defmodule Pelable.Repo.Migrations.CreateBookmarks do
  use Ecto.Migration

  def change do
    create table(:bookmarks) do
      add :title, :string
      add :uuid, :uuid, null: false
      add :creator_id, references(:users, on_delete: :delete_all), null: false
      add :resource_id, references(:resources, on_delete: :delete_all), null: false
      timestamps()
    end
    create unique_index(:bookmarks, [:uuid])
    create index(:bookmarks, [:creator_id])
    create index(:bookmarks, [:resource_id])
  end
end
