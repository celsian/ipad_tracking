class DevicesController < ApplicationController
  before_action :authenticate_user!
  before_action :require_admin

  def index
    @page = (params[:page] || 1).to_i
    @devices = Device.all[(@page-1)*20..((@page-1)*20+19)]
    @last = ((Device.all.length/20)+1).to_i

    @device_search = Device.new
    @search = params[:q]
    if params[:q]
      @devices = Device.search params[:q]
      @last = ((@devices.all.length/20)+1).to_i
      @devices = @devices[(@page-1)*20..((@page-1)*20+19)]
    end
  end

  def show
    @current_user = current_user
    @device = Device.find(params[:id])
    @history = @device.notes

    @student_search = Student.new
    if params[:q]
      @students_search = Student.search params[:q]
    end

    @note = Note.new
  end

  def new
    @device = Device.new
  end

  def create
    @device = Device.new device_params
    @device.serial_number.upcase!

    if @device.save #If it can save, redirects to movie path, otherwise renders new page again (and errors are displayed)
      Note.create(device: @device, note: "Device #{@device.serial_number} was added to inventory.")
      redirect_to devices_path, flash: {success: "Device was created."}
    else
      render :new
    end
  end

  def edit
    @device = Device.find(params[:id])
  end

  def update
    @device = Device.find(params[:id])
    serial = @device.serial_number
    device_type = @device.device_type
    district_tag = @device.district_tag
    if @device.update device_params
      Note.create(device: @device, note: "Device information was updated from Serial: #{serial}, Device: #{device_type}, District Tag: #{district_tag}.")
      redirect_to device_path(@device), flash: {success: "Device was updated."}
    else
      render :edit
    end
  end

  def meraki
    url = "https://n48.meraki.com/EUHSD-Systems-Ma/n/nuDCmcm/manage/pcc/list#q=" + params[:serial]
    redirect_to url
  end

  def destroy
    Device.find(params[:id]).destroy
    
    redirect_to devices_path, flash: {success: "Device was deleted."}
  end

  # def search(params, student)
  #   @device = Device.new
  #   @devices = Device.search params[:device][:serial_number]

  #   redirect_to student
  # end

  def associate
    session[:return_to] ||= request.referer

    device = Device.find(params[:id])
    student = Student.find(params[:student])
    user = current_user

    if device.student
      redirect_to session.delete(:return_to), flash: {error: "Device #{device.device_type} #{device.serial_number} #{device.district_tag} already has an owner: #{device.student.id_number}"}
    else
      device.associate(student, user)
      redirect_to session.delete(:return_to), flash: {success: "Added #{device.device_type} #{device.serial_number} #{device.district_tag} to #{student.id_number}."}
    end
  end

  def deassociate
    session[:return_to] ||= request.referer

    device = Device.find(params[:id])
    student = device.student
    user = current_user
    device.deassociate(user)
    
    redirect_to session.delete(:return_to), flash: {success: "Removed #{device.device_type} #{device.serial_number} #{device.district_tag} from user."}
  end

  private

  def device_params
    params.require(:device).permit(:device_type, :serial_number, :district_tag)
  end

  def require_admin
    unless current_user.admin == true
      redirect_to root_path, flash: {error: "You are not authorized to perform that action."}
    end
  end
end
