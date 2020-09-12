defmodule Pelable.Repo.Migrations.ModifyWorkspaceMemberWithdrawalPersonal do
  use Ecto.Migration

  def change do
    alter table(:workspace_member) do
      add :withdrawal, :naive_datetime
      add :personal?, :boolean, null: false
      remove :role
    end
    create index(:workspace_member, [:user_id, :personal?])
  end
end