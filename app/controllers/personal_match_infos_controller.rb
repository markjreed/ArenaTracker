class PersonalMatchInfosController < ApplicationController
  before_action :set_personal_match_info, only: [:show, :edit, :update, :destroy]

  # GET /personal_match_infos
  # GET /personal_match_infos.json
  def index
    @personal_match_infos = PersonalMatchInfo.all
  end

  # GET /personal_match_infos/1
  # GET /personal_match_infos/1.json
  def show
  end

  # GET /personal_match_infos/new
  def new
    @personal_match_info = PersonalMatchInfo.new
  end

  # GET /personal_match_infos/1/edit
  def edit
  end

  # POST /personal_match_infos
  # POST /personal_match_infos.json
  def create
    @personal_match_info = PersonalMatchInfo.new(personal_match_info_params)

    respond_to do |format|
      if @personal_match_info.save
        format.html { redirect_to @personal_match_info, notice: 'Personal match info was successfully created.' }
        format.json { render :show, status: :created, location: @personal_match_info }
      else
        format.html { render :new }
        format.json { render json: @personal_match_info.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /personal_match_infos/1
  # PATCH/PUT /personal_match_infos/1.json
  def update
    respond_to do |format|
      if @personal_match_info.update(personal_match_info_params)
        format.html { redirect_to @personal_match_info, notice: 'Personal match info was successfully updated.' }
        format.json { render :show, status: :ok, location: @personal_match_info }
      else
        format.html { render :edit }
        format.json { render json: @personal_match_info.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /personal_match_infos/1
  # DELETE /personal_match_infos/1.json
  def destroy
    @personal_match_info.destroy
    respond_to do |format|
      format.html { redirect_to personal_match_infos_url, notice: 'Personal match info was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_personal_match_info
      @personal_match_info = PersonalMatchInfo.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def personal_match_info_params
      params.require(:personal_match_info).permit(:player_id, :match_id, :talents, :glyphs, :note, :fight_number, :winner)
    end
end
