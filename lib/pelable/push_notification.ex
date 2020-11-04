defmodule Pelable.PushNotification do
    use Oban.Worker, queue: :events, max_attempts: 3
    alias Pelable.Habits

    @impl Oban.Worker
    def perform(%Oban.Job{args: %{"reminder_uuid" => uuid} = args}) do
      reminder = Habits.get_reminder_by_uuid(uuid)
      Habits.send_reminder_to_one_signal(reminder)
    end
end