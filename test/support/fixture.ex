defmodule Pelable.Fixture do
    alias Pelable.WorkProjects
    alias Pelable.Users.User
    alias Pelable.Repo

    def fixture(:user) do
        Repo.insert %User{email: "carlos12@gmail.com", username: "csisnett12"}
    end
end