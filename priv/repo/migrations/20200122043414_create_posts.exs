defmodule Pelable.Repo.Migrations.CreatePosts do
  use Ecto.Migration

  def change do
    create table(:posts) do
      add :body, :text
      add :body_html, :text
      add :uuid, :uuid

      timestamps()
    end

    create unique_index(:posts, [:uuid])
  end
end
