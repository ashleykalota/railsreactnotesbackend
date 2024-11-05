class NotesController < ApplicationController
  before_action :set_note, only: %i[show update destroy]
  before_action :authorized

  # GET /notes
  def index
    @notes = Note.where(user: @user.id)

    render json: @notes, status: :ok
  end

  # GET /notes/1
  def show
    render json: @note, status: :ok
  end

  # POST /notes
  def create
    @note = Note.new(note_params)
    @note.user = @user # Associate the current user with the note

    if @note.save
      render json: @note, status: :created, location: @note
    else
      render json: { errors: @note.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /notes/1
  def update
    if @note.update(note_params)
      render json: @note, status: :ok
    else
      render json: { errors: @note.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # DELETE /notes/1
  def destroy
    if @note
      @note.destroy
      head :no_content  # Return a 204 No Content response
    else
      render json: { error: 'Note not found' }, status: :not_found
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_note
    @note = Note.find_by(id: params[:id]) # Use find_by to avoid exceptions
    render json: { error: 'Note not found' }, status: :not_found unless @note
  end

  # Only allow a list of trusted parameters through.
  def note_params
    params.require(:note).permit(:title, :body) # Removed :user_id, as it should be set in the controller
  end
end
