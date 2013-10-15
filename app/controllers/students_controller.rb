class StudentsController < ApplicationController
  before_action :authenticate_user!
  before_action :require_admin

  def index
    @students = Student.all

    @student_search = Student.new
    if params[:q]
      @students = Student.search params[:q]
    end
  end

  def show
    @student = Student.find(params[:id])
    @devices = @student.devices
    @history = @student.notes

    @device_search = Device.new
    if params[:q]
      @devices_search = Device.search params[:q]
    end
  end

  def new
    @student = Student.new
  end

  def create
    @student = Student.new student_params
    @student.title_case

    if @student.save
      Note.create(student: @student, note: "Student #{@student.id_number} was created.")
      redirect_to students_path, flash: {success: "Student was created."}
    else
      render :new
    end
  end

  def destroy
    Student.find(params[:id]).destroy
    
    redirect_to students_path, flash: {success: "Student was deleted."}
  end

  private

  def student_params
    params.require(:student).permit(:first_name, :last_name, :id_number)
  end

  def require_admin
    unless current_user.admin == true
      redirect_to root_path, flash: {error: "You are not authorized to perform that action."}
    end
  end

end
