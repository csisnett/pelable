defmodule Pelable.Learn.Policy do
    @behaviour Bodyguard.Policy

    alias Pelable.Users.User
    alias Pelable.Learn.Post

    #For Posts

    #authorize any user to create a new post
    def authorize(:create_post, _, _) do
        true
    end

    # authorize users to edit/delete their own posts
    def authorize(action, %User{id: user_id}, %Post{creator_id: user_id}) when action in [:update_post, :delete_post] do
        true
    end

    #Deny every other scenario
    def authorize(_,_,_) do
        false
    end

end