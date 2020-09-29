defmodule PelableWeb.SettingController do
  use PelableWeb, :controller

  alias Pelable.Accounts
  alias Pelable.Accounts.Setting

  def index(conn, _params) do
    current_user = conn.assigns.current_user

    settings = Accounts.list_user_settings(current_user)
    render(conn, "index.html", settings: settings)
  end

  def new(conn, _params) do
    changeset = Accounts.change_setting(%Setting{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"setting" => setting_params}) do
    case Accounts.create_setting(setting_params) do
      {:ok, setting} ->
        conn
        |> put_flash(:info, "Setting created successfully.")
        |> redirect(to: Routes.setting_path(conn, :show, setting))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    setting = Accounts.get_setting!(id)
    render(conn, "show.html", setting: setting)
  end

  def edit(conn, %{"id" => id}) do
    setting = Accounts.get_setting!(id)
    changeset = Accounts.change_setting(setting)
    render(conn, "edit.html", setting: setting, changeset: changeset)
  end

  def update(conn, %{"id" => id, "setting" => setting_params}) do
    setting = Accounts.get_setting!(id)

    case Accounts.update_setting(setting, setting_params) do
      {:ok, setting} ->
        conn
        |> put_flash(:info, "Setting updated successfully.")
        |> redirect(to: Routes.setting_path(conn, :show, setting))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", setting: setting, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    setting = Accounts.get_setting!(id)
    {:ok, _setting} = Accounts.delete_setting(setting)

    conn
    |> put_flash(:info, "Setting deleted successfully.")
    |> redirect(to: Routes.setting_path(conn, :index))
  end
end
