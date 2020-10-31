defmodule PelableWeb.LayoutView do
  use PelableWeb, :view

  def show_web_push?(conn) do
    case conn.request_path do
      "/chat/" <> uuid -> true
      other -> false 
    end
  end

  def default_title_or_not(conn) do
    case Map.has_key?(conn.assigns, :page_title) do
      true -> conn.assigns.page_title
      false -> "Start Building! - Welcome to the Pelable Community"
    end
  end


end
