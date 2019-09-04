defmodule PelableWeb.WorkProjectView do
  use PelableWeb, :view

  def required_or_optional?(:required, %{} = user_story) do
    user_story.required?
  end

  def required_or_optional?(:optional, %{} = user_story) do
    user_story.required? == false
  end

  def required_user_story?(%{} = user_story) do
    required_or_optional?(:required, user_story)
  end

  def optional_user_story?(%{} = user_story) do
    required_or_optional?(:optional, user_story)
  end

  #[] -> boolean
  # Returns false if there isn't a single user story with required? = false
  def optional_user_stories?(user_stories) when is_list(user_stories) do
    Enum.reduce(user_stories, false, fn u, acc -> (optional_user_story?(u)) || acc end)
  end

end
