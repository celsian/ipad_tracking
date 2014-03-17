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

    @total = @student.finance_total

    @note = Note.new
    @finance = Finance.new

    @device_search = Device.new
    if params[:q]
      @devices_search = Device.search params[:q]
    end
  end

  def new
    @student = Student.new
  end

  def edit
    @student = Student.find(params[:id])
  end

  def create
    @student = Student.new student_params
    @student.title_case

    if @student.save
      Note.create(student: @student, note: "Student #{@student.id_number} was created.")
      redirect_to students_path, flash: {success: "Student was created."}
    else
      errors = ""
      @student.errors.full_messages.each do |message|
        errors += (" " + message + ".")
      end
      flash[:error] = "<B>ERROR:</B> #{errors}"
      render :new
    end
  end

  def update
    @student = Student.find(params[:id])
    if @student.update_attributes(student_params)
      redirect_to student_path(@student), flash: {success: "Student was updated."}
    else
      errors = ""
      @student.errors.full_messages.each do |message|
        errors += (" " + message + ".")
      end
      flash[:error] = "<B>ERROR:</B> #{errors}"
      render :edit
    end
  end

  def destroy
    Student.find(params[:id]).destroy
    
    redirect_to students_path, flash: {success: "Student was deleted."}
  end

  private

  def student_params
    params.require(:student).permit(:first_name, :last_name, :id_number, :grade_level, :insurance,
                                    :current_school, :parent_1_name, :parent_1_phone, :parent_2_name,
                                    :parent_2_phone)
  end

  def require_admin
    unless current_user.admin == true
      redirect_to root_path, flash: {error: "You are not authorized to perform that action."}
    end
  end
end
