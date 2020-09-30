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

    resources "/projects", ProjectController
    get "/p/:slug/:uuid", ProjectController, :show
    resources "/goals", GoalController
    get "/program", PageController, :landing
    get "/apply", PageController, :apply
    get "/home", PageController, :home
    get "/", PageController, :index
    get "/layout", PageController, :layout
    get "/chat/:uuid", ChatroomController, :show
    get "/chat", PageController, :chat
    get "/guide", PageController, :guide
    get "/break", PageController, :break

    resources "/post", PostController, except: [:show, :edit, :update, :delete]
    get "/post/:title/:uuid", PostController, :show
    get "/post/:title/:uuid/edit", PostController, :edit
    put "/post/:title/:uuid", PostController, :update
    delete "/post/:title/:uuid", PostController, :delete
    
  end

  scope "/", PelableWeb do
    pipe_through [:browser, :protected]
    post "chat/:uuid/new_participant", ChatroomController, :new_participant
    post "chat/:uuid/decline", ChatroomController, :decline
    post "chat/:uuid/new_team", ChatroomController, :new_team

    get "/projects/new", ProjectController, :new
    post "/projects", ProjectController, :create

    get "/settings/", SettingController, :index
    put "/settings", SettingController, :update
    
  end

  scope "/", PelableWeb do
    pipe_through [:api, :protected]
  end

  # Other scopes may use custom stacks.
  # scope "/api", PelableWeb do
  #   pipe_through :api
  # end
end
