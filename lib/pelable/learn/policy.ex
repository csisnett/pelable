defmodule Pelable.Learn.Policy do
    @behaviour Bodyguard.Policy

    alias Pelable.Users.User
    alias Pelable.Learn.{Post, Task}

    #For Posts

    

    #authorize any user to create a new post
    def authorize(:create_post, _, _) do
        true
    end

    # authorize users to edit/delete their own posts
    def authorize(action, %User{id: user_id}, %Post{creator_id: user_id}) when action in [:update_post, :delete_post] do
        true
    end

    #Authorize admins to do everything
    
    def authorize(action, %User{site_role: "admin"}, _) do
        true
    end


    #authorize any user to create a new task
    def authorize(:create_task, _, _) do
        true
    end
    
        # authorize users to update their taskss
    def authorize(action, %User{id: user_id}, %Task{creator_id: user_id}) when action in [:update_task] do
        true
    end

    

    #Deny every other scenario
    def authorize(_,_,_) do
        false
    end

end