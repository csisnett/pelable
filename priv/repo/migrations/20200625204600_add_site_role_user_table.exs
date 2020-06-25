defmodule Pelable.Repo.Migrations.AddSiteRoleUserTable do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :site_role, :string, default: "regular"
    end
  end
end
