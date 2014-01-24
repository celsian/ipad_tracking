class AdminsController < ApplicationController
  before_action :authenticate_user!
  # before_action :require_admin

  def index

  end

  def logs
    @page = (params[:page] || 1).to_i
    @notes = Note.all[(@page-1)*20..((@page-1)*20+19)]
    @last = ((Note.all.length/20)+1).to_i
  end

  def import_all

  end

  def import_all_submit
    Student.import_all(params[:file])
    redirect_to root_path, flash: {success: "Students & Devices imported."}
  end

  def update_admins
    User.disable_all_admins
    User.update_admins(params, current_user)

    redirect_to administrator_path, flash: {success: "Administrators Updated."}
  end
  
  private

  def require_admin
    unless current_user.admin == true
      redirect_to root_path, flash: {error: "You are not authorized to perform that action."}
    end
  end

end