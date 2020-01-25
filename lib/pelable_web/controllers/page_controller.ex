defmodule PelableWeb.PageController do
  use PelableWeb, :controller

  @chat_url "/chat/c3EMBSqNzdRo"

  def index(conn, _params) do
    if conn.assigns.current_user == nil do
      redirect(conn, to: "/program")
      else
        redirect(conn, to: @chat_url)
      end
  end

  def landing(conn, _params) do
    conn = put_layout conn, false
    render(conn, "landing.html")
  end

  def break(conn, _params) do
    render(conn, "break.html")
  end

  def apply(conn, _params) do
    render(conn, "application.html")
  end

  def home(conn, _params) do
    render(conn, "home.html")
  end

  def layout(conn, _params) do
    render(conn, "layout.html")
  end

  def chat(conn, _params) do
    redirect(conn, to: "/chat/c3EMBSqNzdRo")
  end

  def guide(conn, _params) do
    redirect(conn, external: "https://www.notion.so/pelable/The-Pelable-Guide-67f5a87eac70415a8d9f687fc1b3fc37")
  end
end
