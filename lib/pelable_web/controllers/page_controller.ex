defmodule PelableWeb.PageController do
  use PelableWeb, :controller

  def index(conn, _params) do
    redirect(conn, to: "/landing")
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
    redirect(conn, to: "/chat/AZ3X37GsBebR")
  end
end
