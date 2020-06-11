defmodule Pelable.Repo.Migrations.DeleteBodyHtmlFromPost do
  use Ecto.Migration

  def change do
    alter table(:posts) do
      remove :body_html
    end
  end
end
