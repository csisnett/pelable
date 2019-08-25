defmodule PelableWeb.PageController do
  use PelableWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
