class WelcomeController < ApplicationController
  def index
    if current_user
      if !current_user.admin
       current_user.admin = true
       current_user.save
     end
   end
  end
end