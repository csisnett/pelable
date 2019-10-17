defmodule PelableWeb.ChatTracker do
    alias Pelable.Chat
    alias PelableWeb.Endpoint
    use GenServer

  def start(state) do
    GenServer.start(__MODULE__, state, [])
  end

  @impl true
  def init(state) do
    Process.monitor(state["pid"])
    {:ok, state}
  end

  ## Callbacks

  @impl true
  def handle_info({:DOWN, _ref, :process, _object, _reason}, state) do
    Chat.update_last_connection(state["user"], state["chatroom"])
    {:stop, :normal, state}
  end
end