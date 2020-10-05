defmodule Pelable.Habits.Policy do
    @behaviour Bodyguard.Policy

    alias Pelable.Users.User
    alias Pelable.Habits.{Habit, Streak, HabitCompletion}

    #For Posts

    

    # authorize users to update and log their own habits
    def authorize(action, %User{id: user_id}, %Habit{user_id: user_id}) when action in [:update_habit, :log_habit] do
        true
    end

    #Authorize admins to do everything
    
    def authorize(action, %User{site_role: "admin"}, _) do
        true
    end

    

    #Deny every other scenario
    def authorize(_,_,_) do
        false
    end

end