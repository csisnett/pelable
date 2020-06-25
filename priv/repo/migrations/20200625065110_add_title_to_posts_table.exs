defmodule Pelable.Repo.Migrations.AddTitleToPostsTable do
  use Ecto.Migration

  def change do
    alter table(:posts) do
      add :title, :string
    end
  end
end
