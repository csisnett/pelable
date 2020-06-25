defmodule Pelable.Repo.Migrations.AddSlugFieldPostsTable do
  use Ecto.Migration

  def change do
    alter table(:posts) do
      add :slug, :string, null: false
    end
  end
end
