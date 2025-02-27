defmodule PelableWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :pelable

  socket "/socket", PelableWeb.UserSocket,
    websocket: true,
    longpoll: false,
    check_origin: ["//locahost", "//pelable.com"]

  # Serve at "/" the static files from "priv/static" directory.
  #
  # You should set gzip to true if you are running phx.digest
  # when deploying your static files in production.
  plug RemoteIp
  plug Plug.Static,
    at: "/",
    from: :pelable,
    gzip: false,
    only: ~w(css fonts images js favicon.ico robots.txt OneSignalSDKUpdaterWorker.js OneSignalSDKWorker.js blue)

  # Code reloading can be explicitly enabled under the
  # :code_reloader configuration of your endpoint.
  if code_reloading? do
    socket "/phoenix/live_reload/socket", Phoenix.LiveReloader.Socket
    plug Phoenix.LiveReloader
    plug Phoenix.CodeReloader
  end

  plug Plug.RequestId
  plug Plug.Logger

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Phoenix.json_library()

  plug Plug.MethodOverride
  plug Plug.Head

  # The session will be stored in the cookie and signed,
  # this means its contents can be read but not tampered with.
  # Set :encryption_salt if you would also like to encrypt it.
  plug Plug.Session,
    store: :cookie,
    key: "_pelable_key",
    signing_salt: "hgkTB4VM"

  plug Pow.Plug.Session, otp_app: :pelable
  plug PowPersistentSession.Plug.Cookie
  
  plug CORSPlug
  plug PelableWeb.Router
end
