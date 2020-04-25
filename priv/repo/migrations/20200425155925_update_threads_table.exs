defmodule Pelable.Repo.Migrations.UpdateThreadsTable do
  use Ecto.Migration

  def change do
    alter table(:threads) do
      remove :first_post_id
    end
  end
end
