defmodule Pelable.Repo.Migrations.CreateUserStories do
  use Ecto.Migration

  def change do
    create table(:user_stories) do
      add :body, :string

      timestamps()
    end

  end
end
