defmodule PelableWeb.LayoutView do
  use PelableWeb, :view

  def show_web_push?(conn) do
    case conn.request_path do
      "/chat/" <> uuid -> true
      other -> false 
    end
  end
end
