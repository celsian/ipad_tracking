class DevicesController < ApplicationController
  before_action :authenticate_user!
  
  def index
    @devices = Device.all

    @device_search = Device.new
    if params[:q]
      @devices = Device.search params[:q]
    end
  end

  def show
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

    if device.student
      redirect_to session.delete(:return_to), flash: {error: "Device #{device.device_type} #{device.serial_number} #{device.district_tag} already has an owner: #{device.student.id_number}"}
    else
      device.associate(student)
      redirect_to session.delete(:return_to), flash: {success: "Added #{device.device_type} #{device.serial_number} #{device.district_tag} to #{student.id_number}."}
    end
  end

  def deassociate
    session[:return_to] ||= request.referer

    device = Device.find(params[:id])
    student = device.student
    device.deassociate
    
    redirect_to session.delete(:return_to), flash: {success: "Removed #{device.device_type} #{device.serial_number} #{device.district_tag} from user."}
  end

  private

  def device_params
    params.require(:device).permit(:device_type, :serial_number, :district_tag)
  end
end
