defmodule Pelable.Repo.Migrations.DropSectionTable do
  use Ecto.Migration

  def change do
    drop (constraint(:threads, :threads_section_id_fkey))
    drop table("sections")
  end
end
