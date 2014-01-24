class NotesController < ApplicationController
  before_action :authenticate_user!
  before_action :require_admin
  
  def new
    @note = Note.new
  end

  def create
    session[:return_to] ||= request.referer

    @note = Note.new note_params

    if @note.save
      redirect_to session.delete(:return_to), flash: {success: "Note was created."}
    else
      render :new
    end
  end

  def destroy
    session[:return_to] ||= request.referer
    Note.find(params[:id]).destroy
    
    redirect_to session.delete(:return_to), flash: {success: "Note was deleted."}
  end

  private

  def note_params
    params.require(:note).permit(:note, :device_id, :student_id, :user_id)
  end

  def require_admin
    unless current_user.admin == true
      redirect_to root_path, flash: {error: "You are not authorized to perform that action."}
    end
  end

end
