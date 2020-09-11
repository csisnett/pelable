defmodule Pelable.Repo.Migrations.AddWithdrawalDeleteRoleWorkspaceMember do
  use Ecto.Migration

  def change do
    alter table(:workspace_member) do
      add :withdrawal, :naive_datetime
      remove :role
    end
  end
end
