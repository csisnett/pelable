defmodule Pelable.Repo.Migrations.DropSectionTable do
  use Ecto.Migration

  def change do
    drop table("sections")
  end
end
