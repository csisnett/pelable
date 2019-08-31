defmodule PelableWeb.PageController do
  use PelableWeb, :controller

  def index(conn, _params) do
    redirect(conn, to: "/landing")
  end

  def landing(conn, _params) do
    conn = put_layout conn, false
    render(conn, "landing.html")
  end
  def home(conn, _params) do
    render(conn, "home.html")
  end
end
