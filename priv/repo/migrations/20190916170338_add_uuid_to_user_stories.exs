defmodule Pelable.Repo.Migrations.AddUuidToUserStories do
  use Ecto.Migration

  def change do
    alter table(:user_stories) do
      add :uuid, :uuid, null: false
    end
    create unique_index(:user_stories, [:uuid])
  end
end
