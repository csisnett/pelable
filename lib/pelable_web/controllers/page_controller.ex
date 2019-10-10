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

  def healthcheck(conn, _params) do
    text(conn, "ok")
  end
end
