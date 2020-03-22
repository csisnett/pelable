defmodule PelableWeb.SectionController do
  use PelableWeb, :controller

  alias Pelable.Learn
  alias Pelable.Learn.Section

  def index(conn, _params) do
    sections = Learn.list_sections()
    render(conn, "index.html", sections: sections)
  end

  def new(conn, _params) do
    changeset = Learn.change_section(%Section{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"section" => section_params}) do
    case Learn.create_section(section_params) do
      {:ok, section} ->
        conn
        |> put_flash(:info, "Section created successfully.")
        |> redirect(to: Routes.section_path(conn, :show, section))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    section = Learn.get_section!(id)
    render(conn, "show.html", section: section)
  end

  def edit(conn, %{"id" => id}) do
    section = Learn.get_section!(id)
    changeset = Learn.change_section(section)
    render(conn, "edit.html", section: section, changeset: changeset)
  end

  def update(conn, %{"id" => id, "section" => section_params}) do
    section = Learn.get_section!(id)

    case Learn.update_section(section, section_params) do
      {:ok, section} ->
        conn
        |> put_flash(:info, "Section updated successfully.")
        |> redirect(to: Routes.section_path(conn, :show, section))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", section: section, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    section = Learn.get_section!(id)
    {:ok, _section} = Learn.delete_section(section)

    conn
    |> put_flash(:info, "Section deleted successfully.")
    |> redirect(to: Routes.section_path(conn, :index))
  end
end
