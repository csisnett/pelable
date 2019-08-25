defmodule Pelable.Repo.Migrations.CreateProjects do
  use Ecto.Migration

  def change do
    create table(:projects) do
      add :creator_id, references(:users) 
      timestamps()
    end

  end
end
