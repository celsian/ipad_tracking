class DevicesController < ApplicationController
  def index
    @devices = Device.all
  end

  def show
    @device = Device.find(params[:id])
  end

  def new
    @device = Device.new
  end

  def create
    @device = Device.new device_params
    @device.serial_number.upcase!

    if @device.save #If it can save, redirects to movie path, otherwise renders new page again (and errors are displayed)
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
    device = Device.find(params[:id])
    student = Student.find(params[:format])

    if device.student
      redirect_to student, flash: {error: "Device #{device.device_type} #{device.serial_number} #{device.district_tag} already has an owner: #{device.student.id_number}"}
    else
      device.associate(student)
      redirect_to student, flash: {success: "Added #{device.device_type} #{device.serial_number} #{device.district_tag} to #{student.id_number}."}
    end
  end

  def deassociate
    device = Device.find(params[:id])
    student = device.student
    device.deassociate
    
    redirect_to student, flash: {success: "Removed #{device.device_type} #{device.serial_number} #{device.district_tag} from user."}
  end

  private

  def device_params
    params.require(:device).permit(:device_type, :serial_number, :district_tag)
  end
end
