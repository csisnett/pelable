defmodule PelableWeb.RewardController do
  use PelableWeb, :controller

  alias Pelable.Habits
  alias Pelable.Habits.Reward

  def index(conn, _params) do
    rewards = Habits.list_rewards()
    render(conn, "index.html", rewards: rewards)
  end

  def new(conn, _params) do
    changeset = Habits.change_reward(%Reward{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"reward" => reward_params}) do
    user = conn.assigns.current_user
    case Habits.create_reward(reward_params, user) do
      {:ok, reward} ->
        conn
        |> put_flash(:info, "Reward created successfully.")
        |> redirect(to: Routes.reward_path(conn, :show, reward.slug, reward.uuid))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"uuid" => uuid}) do
    reward = Habits.get_reward_by_uuid(uuid)
    render(conn, "show.html", reward: reward)
  end

  def edit(conn, %{"uuid" => uuid}) do
    reward = Habits.get_reward_by_uuid(uuid)
    changeset = Habits.change_reward(reward)
    render(conn, "edit.html", reward: reward, changeset: changeset)
  end

  def update(conn, %{"uuid" => uuid, "reward" => reward_params}) do
    reward = Habits.get_reward_by_uuid(uuid)

    case Habits.update_reward(reward, reward_params) do
      {:ok, reward} ->
        conn
        |> put_flash(:info, "Reward updated successfully.")
        |> redirect(to: Routes.reward_path(conn, :show, reward.slug, reward.uuid))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", reward: reward, changeset: changeset)
    end
  end

  def delete(conn, %{"uuid" => uuid}) do
    reward = Habits.get_reward_by_uuid(uuid)
    {:ok, _reward} = Habits.delete_reward(reward)

    conn
    |> put_flash(:info, "Reward deleted successfully.")
    |> redirect(to: Routes.reward_path(conn, :index))
  end
end
