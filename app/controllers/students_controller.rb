class StudentsController < ApplicationController
  require 'csv'

  before_action :authenticate_user!
  before_action :require_admin

  def index #links will go 0, 20, 40, 60...
    @page = (params[:page] || 1).to_i
    @students = Student.all[(@page-1)*20..((@page-1)*20+19)]
    @last = ((Student.all.length/20)+1).to_i

    @student_search = Student.new
    @search = params[:q]
    if params[:q]
      @students = (Student.search params[:q])
      @last = ((@students.all.length/20)+1).to_i
      @students = @students[(@page-1)*20..((@page-1)*20+19)]
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

  def import_all
    Student.import_all(params[:file])
    redirect_to students_path, flash: {success: "Students & Devices imported."}
  end

  private

  def student_params
    params.require(:student).permit(:first_name, :last_name, :id_number, :grade_level)
  end

  def require_admin
    unless current_user.admin == true
      redirect_to root_path, flash: {error: "You are not authorized to perform that action."}
    end
  end

end
