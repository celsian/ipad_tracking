class StudentsController < ApplicationController
  def index
    @students = Student.all
  end

  def show
    @student = Student.find(params[:id])
    @devices = @student.devices

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

    if @student.save #If it can save, redirects to movie path, otherwise renders new page again (and errors are displayed)
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

end
