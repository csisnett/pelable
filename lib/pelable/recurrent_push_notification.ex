defmodule Pelable.RecurrentPushNotification do
    use Oban.Worker, queue: :events, max_attempts: 4
    alias Pelable.Habits

    @impl Oban.Worker
    def perform(%Oban.Job{args: %{"reminder_uuid" => uuid} = args, attempt: 1}) do
        reminder = Habits.get_reminder_by_uuid(uuid)
        next_time = Habits.time_for_reminder(reminder)
        
        args
        |> new(schedule_in: next_time)
        |> Oban.insert()
        
        Habits.send_reminder_to_one_signal(reminder)
    end

    def perform(%Oban.Job{args: %{"reminder_uuid" => uuid} = args}) do
        reminder = Habits.get_reminder_by_uuid(uuid)
        Habits.send_reminder_to_one_signal(reminder)
    end
end