defmodule Pelable.Repo.Migrations.CreateThreadPosts do
  use Ecto.Migration

  def change do
    create table(:thread_posts) do
      add :thread_id, references(:threads, on_delete: :delete_all), null: false
      add :post_id, references(:posts, on_delete: :delete_all), null: false

      timestamps()
    end

    create index(:thread_posts, [:thread_id])
    create index(:thread_posts, [:post_id])
  end
end
