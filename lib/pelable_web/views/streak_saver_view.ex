defmodule PelableWeb.StreakSaverView do
  use PelableWeb, :view
  alias PelableWeb.StreakSaverView

  def render("index.json", %{streak_saver: streak_saver}) do
    %{data: render_many(streak_saver, StreakSaverView, "streak_saver.json")}
  end

  def render("show.json", %{streak_saver: streak_saver}) do
    %{data: render_one(streak_saver, StreakSaverView, "streak_saver.json")}
  end

  def render("streak_saver.json", %{streak_saver: streak_saver}) do
    %{id: streak_saver.id,
      start_date: streak_saver.start_date,
      end_date: streak_saver.end_date}
  end
end
