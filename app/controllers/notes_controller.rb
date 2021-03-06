class NotesController < ApplicationController
  before_action :set_note, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, except: [:main, :rank, :index, :show]
  
  def main
  end 
  
  def rank
  end

  def sports
  end

  def channelinfo
  end

  def forlater
  end
  
  # GET /notes
  # GET /notes.json
  def index
    # @notes = Note.all  // 기존에 Note.all 을 kaminari gem을 통해서 pagination 하면서 아래의 코드로 수정되었다.
    # 기존의 index.html.erb의 코드에서는 <% paginate @notes %> 라는 코드가 추가된것 말고는 달라진 것이 하나도 없다.
    @notes = Note.page params[:page]
  end

  # GET /notes/1
  # GET /notes/1.json
  def show
    @token = form_authenticity_token
    @note = Note.find params[:id]
    @user = current_user
  end

  # GET /notes/new
  def new
    @note = Note.new
  end

  # GET /notes/1/edit
  def edit
    check_user
  end

  # POST /notes
  # POST /notes.json
  def create
    @note = Note.new(note_params)

    respond_to do |format|
      if @note.save
        format.html { redirect_to @note, notice: 'Note was successfully created.' }
        format.json { render :show, status: :created, location: @note }
      else
        format.html { render :new }
        format.json { render json: @note.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /notes/1
  # PATCH/PUT /notes/1.json
  def update
    respond_to do |format|
      if @note.update(note_params)
        format.html { redirect_to @note, notice: 'Note was successfully updated.' }
        format.json { render :show, status: :ok, location: @note }
      else
        format.html { render :edit }
        format.json { render json: @note.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /notes/1
  # DELETE /notes/1.json
  def destroy
    check_user
    @note.destroy
    respond_to do |format|
      format.html { redirect_to notes_url, notice: 'Note was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_note
      @note = Note.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def note_params
      params.require(:note).permit(:title, :content, :user_id, :user_email)
    end
    
    def check_user
      if @note.user != current_user
        redirect_to notes_path
      end
    end
end
