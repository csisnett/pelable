defmodule PelableWeb.Pow.Routes do

    use Pow.Phoenix.Routes

    alias PelableWeb.Router.Helpers, as: Routes

    @impl true
    def after_sign_out_path(conn), do: Routes.page_path(conn, :apply)

    @impl true
    def after_sign_in_path(conn), do: Routes.chatroom_path(conn, :show, "c3EMBSqNzdRo")

    @impl true
    def after_registration_path(conn), do: Routes.session_path(conn, :new)

  end