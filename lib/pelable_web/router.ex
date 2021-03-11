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
    plug PelableWeb.Pow.Plug, otp_app: :pelable
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug Pelable.PlugAttack
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug PelableWeb.Pow.Plug, otp_app: :pelable
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

    resources "/habits", HabitController, except: [:show, :edit, :update, :delete]
    
    get "habits/:uuid", HabitController, :show
    get "habits/:uuid/edit", HabitController, :edit
    put "habits/update-reward/:uuid", HabitController, :update_current_reward
    delete "habits/:uuid", HabitController, :delete

    resources "/tasks", TaskController, except: [:show, :edit, :update, :delete]

    get "/tasks/:slug/:uuid", TaskController, :show
    get "/tasks/:slug/:uuid/edit", TaskController, :edit
    put "/tasks/:slug/:uuid", TaskController, :update
    delete "/tasks/:slug/:uuid", TaskController, :delete

    resources "/rewards", RewardController, except: [:show, :edit, :update, :delete]

    get "/rewards/:slug/:uuid", RewardController, :show
    get "/rewards/:slug/:uuid/edit", RewardController, :edit
    put "/rewards/:slug/:uuid", RewardController, :update
    delete "/rewards/:slug/:uuid", RewardController, :delete

    get "/earned-rewards/", HabitCompletionRewardController, :index
    get "/earned-rewards/:uuid", HabitCompletionRewardController, :show
    put "/earned-rewards/:uuid", HabitCompletionRewardController, :take_reward

    resources "/bookmarks", BookmarkController, except: [:show, :edit, :update, :delete]
    
    get "/bookmarks/:uuid", BookmarkController, :show
    get "/bookmarks/:uuid/edit", BookmarkController, :edit
    put "/bookmarks/:uuid", BookmarkController, :update
    delete "/bookmarks/:uuid", BookmarkController, :delete
    
    resources "/reminders", ReminderController

    get "/tracker", TrackerController, :index    
  end

  scope "/", PelableWeb do
    pipe_through [:api, :protected]

    post "/log-habit/:uuid", HabitController, :log_habit
    put "/tasks/:slug/:uuid", TaskController, :update
    put "/habits/:uuid", HabitController, :update_habit

    get "/tracker/:uuid", TrackerController, :show
    get "/tracker/:uuid/edit", TrackerController, :edit
    post "/tracker", TrackerController, :create
    post "/tracker/create_activity/:uuid", TrackerController, :create_new_activity
    put "/terminate-tracker/:uuid", TrackerController, :terminate_tracker
    put "/tracker/:uuid", TrackerController, :update
    delete "/tracker/:uuid", TrackerController, :delete
  end


  # Other scopes may use custom stacks.
  # scope "/api", PelableWeb do
  #   pipe_through :api
  # end
end
