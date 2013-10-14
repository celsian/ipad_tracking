class NotesController < ApplicationController
  
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

  private

  def note_params
    params.require(:note).permit(:note, :device_id, :student_id)
  end
end
