defmodule PelableWeb.Router do
  use PelableWeb, :router
  use Pow.Phoenix.Router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :protected do
    plug Pow.Plug.RequireAuthenticated,
      error_handler: Pow.Phoenix.PlugErrorHandler
  end

  scope "/" do
    pipe_through :browser

    pow_routes()
  end

  scope "/", PelableWeb do
    pipe_through [:browser]

    resources "/projects", WorkProjectController, except: [:show]
    resources "/user_stories", UserStoryController
    resources "/work_project_user_story", WorkProjectUserStoryController
    resources "/project_versions", ProjectVersionController
    resources "/goals", GoalController
    get "/landing", PageController, :landing
    get "/home", PageController, :home
    get "/", PageController, :index
    get "/layout", PageController, :layout
    get "/chat", PageController, :chat
    get "/p/:slug/:uuid", WorkProjectController, :show
  end

  # Other scopes may use custom stacks.
  # scope "/api", PelableWeb do
  #   pipe_through :api
  # end
end
