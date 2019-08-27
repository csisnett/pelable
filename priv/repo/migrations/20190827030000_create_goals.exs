defmodule Pelable.Repo.Migrations.CreateGoals do
  use Ecto.Migration

  def change do
    create table(:goals) do
      add :title, :string

      timestamps()
    end
    create unique_index(:goals, [:title])
  end
end
