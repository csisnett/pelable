defmodule PelableWeb.ReminderController do
  use PelableWeb, :controller

  alias Pelable.Habits
  alias Pelable.Habits.Reminder

  def index(conn, _params) do
    reminders = Habits.list_reminders()
    render(conn, "index.html", reminders: reminders)
  end

  def new(conn, _params) do
    changeset = Habits.change_reminder(%Reminder{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"reminder" => reminder_params}) do
    case Habits.create_reminder(reminder_params) do
      {:ok, reminder} ->
        conn
        |> put_flash(:info, "Reminder created successfully.")
        |> redirect(to: Routes.reminder_path(conn, :show, reminder))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    reminder = Habits.get_reminder!(id)
    render(conn, "show.html", reminder: reminder)
  end

  def edit(conn, %{"id" => id}) do
    reminder = Habits.get_reminder!(id)
    changeset = Habits.change_reminder(reminder)
    render(conn, "edit.html", reminder: reminder, changeset: changeset)
  end

  def update(conn, %{"id" => id, "reminder" => reminder_params}) do
    reminder = Habits.get_reminder!(id)

    case Habits.update_reminder(reminder, reminder_params) do
      {:ok, reminder} ->
        conn
        |> put_flash(:info, "Reminder updated successfully.")
        |> redirect(to: Routes.reminder_path(conn, :show, reminder))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", reminder: reminder, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    reminder = Habits.get_reminder!(id)
    {:ok, _reminder} = Habits.delete_reminder(reminder)

    conn
    |> put_flash(:info, "Reminder deleted successfully.")
    |> redirect(to: Routes.reminder_path(conn, :index))
  end
end
