defmodule PelableWeb.Router do
  use PelableWeb, :router
  use Pow.Phoenix.Router
  use Pow.Extension.Phoenix.Router, otp_app: :pelable
  
  pipeline :browser do
    plug :accepts, ["html"]
    plug Pelable.PlugAttack
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug Pelable.PlugAttack
    plug :fetch_session
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :protected do
    plug Pow.Plug.RequireAuthenticated,
      error_handler: Pow.Phoenix.PlugErrorHandler
  end

  scope "/" do
    pipe_through :browser

    pow_routes()
    pow_extension_routes()
  end

  scope "/", PelableWeb do
    pipe_through [:browser]

    resources "/projects", WorkProjectController, except: [:show, :create, :new]
    get "/p/:slug/:uuid", WorkProjectController, :show
    resources "/project_versions", ProjectVersionController
    resources "/goals", GoalController
    get "/program", PageController, :landing
    get "/apply", PageController, :apply
    get "/home", PageController, :home
    get "/", PageController, :index
    get "/layout", PageController, :layout
    get "/chat/:uuid", ChatroomController, :show
    get "/chat", PageController, :chat
    get "/check39432", PageController, :healthcheck
    get "/guide", PageController, :guide
  end

  scope "/", PelableWeb do
    pipe_through [:browser, :protected]
    post "chat/:uuid/new_participant", ChatroomController, :new_participant
    post "chat/:uuid/decline", ChatroomController, :decline
    get "/p/:slug/:uuid/user-stories/new", UserStoryController, :new
    post "/p/:slug/:uuid/user-stories/new", UserStoryController, :create
    get "/user-stories/:uuid", UserStoryController, :edit
    put "/user-stories/:uuid", UserStoryController, :update
    delete "/user-stories/:uuid", UserStoryController, :delete
    get "/projects/new", WorkProjectController, :new
    post "/projects", WorkProjectController, :create
    get "/start_project/:uuid", WorkProjectController, :start
    post "/start_project/:uuid", WorkProjectController, :start
    
  end

  scope "/", PelableWeb do
    pipe_through [:api, :protected]

    post "/p/slug/:uuid/user_stories", WorkProjectUserStoryController, :create
    put "/p/slug/:uuid/user_stories/:id", WorkProjectUserStoryController, :update
    delete "/p/slug/:uuid/user_stories/:id", WorkProjectUserStoryController, :delete

  end

  # Other scopes may use custom stacks.
  # scope "/api", PelableWeb do
  #   pipe_through :api
  # end
end
