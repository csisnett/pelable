defmodule Pelable.Repo.Migrations.CreateUserStories do
  use Ecto.Migration

  def change do
    create table(:user_stories) do
      add :title, :text

      timestamps()
    end
    create unique_index(:user_stories, [:title])
  end
end
