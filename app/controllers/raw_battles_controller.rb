class RawBattlesController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :set_raw_battle, only: [:show, :edit, :update, :destroy]

  # GET /raw_battles
  # GET /raw_battles.json
  def index
    @raw_battles = RawBattle.all
  end

  # GET /raw_battles/1
  # GET /raw_battles/1.json
  def show
  end

  # GET /raw_battles/new
  def new
    @raw_battle = RawBattle.new
  end

  # GET /raw_battles/1/edit
  def edit
  end

  # POST /raw_battles
  # POST /raw_battles.json
  def create
    @raw_battle = RawBattle.new(raw_battle_params)

    respond_to do |format|
      if @raw_battle.save
        format.html { redirect_to @raw_battle, notice: 'Raw battle was successfully created.' }
        format.json { render :show, status: :created, location: @raw_battle }
      else
        format.html { render :new }
        format.json { render json: @raw_battle.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /raw_battles/1
  # PATCH/PUT /raw_battles/1.json
  def update
    respond_to do |format|
      if @raw_battle.update(raw_battle_params)
        format.html { redirect_to @raw_battle, notice: 'Raw battle was successfully updated.' }
        format.json { render :show, status: :ok, location: @raw_battle }
      else
        format.html { render :edit }
        format.json { render json: @raw_battle.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /raw_battles/1
  # DELETE /raw_battles/1.json
  def destroy
    @raw_battle.destroy
    respond_to do |format|
      format.html { redirect_to raw_battles_url, notice: 'Raw battle was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_raw_battle
      @raw_battle = RawBattle.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def raw_battle_params
      params.require(:raw_battle).permit(:raw_battle_data, :parse_status, :status_message)
    end
end
