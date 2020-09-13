defmodule Pelable.Repo.Migrations.ModifyThreadDeleleSection do
  use Ecto.Migration

  def change do
    alter table(:threads) do
      remove :section_id
    end
    remove index(:threads, [:section_id])
  end
end
