defmodule Pelable.Accounts.Policy do
    @behaviour Bodyguard.Policy

    alias Pelable.Users.User
    alias Pelable.Accounts.Setting

    #For Settings

    

    # authorize users to update their settings
    def authorize(action, %User{id: user_id}, %Setting{user_id: user_id}) when action in [:update_setting] do
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