defmodule Pelable.Repo.Migrations.CreateThreads do
  use Ecto.Migration

  def change do
    create table(:threads) do
      add :title, :string, null: false
      add :uuid, :uuid, null: false
      add :type, :string, null: false
      add :first_post_id, references(:posts, on_delete: :delete_all), null: false
      add :section_id, references(:sections, on_delete: :delete_all)
      add :creator_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create unique_index(:threads, [:uuid])
    create index(:threads, [:first_post_id])
    create index(:threads, [:section_id])
    create index(:threads, [:creator_id])
  end
end
