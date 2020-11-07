defmodule Pelable.Repo.Migrations.CreateResources do
  use Ecto.Migration

  def change do
    create table(:resources) do
      add :url, :string

      timestamps()
    end

  end
end
