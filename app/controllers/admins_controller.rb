class AdminsController < ApplicationController
  before_action :authenticate_user!
  before_action :require_admin

  def index

  end

  private

  def require_admin
    unless current_user.admin == true
      redirect_to root_path, flash: {error: "You are not authorized to perform that action."}
    end
  end

end