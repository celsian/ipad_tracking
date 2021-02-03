class AdminsController < ApplicationController
  before_action :authenticate_user!
  before_action :require_admin

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

  def export_devices
    respond_to do |format|
      format.csv { send_data Device.all.to_csv }
    end
    #How do I flash a notice after this action responds? Probably need Javascript because theres no page reload.
  end

  def export_students
    csvString = CSV.generate do |csv|
      Student.where(active: true).each do |s|
        csvLine = [s.first_name, s.last_name, s.id_number, s.email]
        s.devices.each do |d|
           csvLine << d.device_type
           csvLine << d.serial_number
           csvLine << d.district_tag
        end

        csv << csvLine
      end
    end
    
    respond_to do |format|
      format.csv { send_data csvString }
    end
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

  def student_export_params
    params.require(:student).permit(:grade_level)
  end
end
