class PlayersController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :set_player, only: [:show, :edit, :update, :destroy]

  # GET /players
  # GET /players.json

  def index     
    @filterrific =
      initialize_filterrific(
        Player,
        params[:filterrific],
        select_options: {
          sorted_by: %w{name_asc name_desc
                        server_name_asc server_name_desc
                        class_name_asc class_name_desc
                        spec_name_asc spec_name_desc},
          with_class_name: Player.all.map(&:class_name).uniq,
          with_spec_name: Player.all.map(&:spec_name).uniq,
        }
    ) or return
    @players = @filterrific.find
  end

  # GET /players/1
  # GET /players/1.json
  def show
  end

  # GET /players/new
  def new
    @player = Player.new
  end

  # GET /players/1/edit
  def edit
  end

  # POST /players
  # POST /players.json
  def create
    @player = Player.new(player_params)

    respond_to do |format|
      if @player.save
        format.html { redirect_to @player, notice: 'Player was successfully created.' }
        format.json { render :show, status: :created, location: @player }
      else
        format.html { render :new }
        format.json { render json: @player.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /players/1
  # PATCH/PUT /players/1.json
  def update
    respond_to do |format|
      if @player.update(player_params)
        format.html { redirect_to @player, notice: 'Player was successfully updated.' }
        format.json { render :show, status: :ok, location: @player }
      else
        format.html { render :edit }
        format.json { render json: @player.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /players/1
  # DELETE /players/1.json
  def destroy
    @player.destroy
    respond_to do |format|
      format.html { redirect_to players_url, notice: 'Player was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_player
      @player = Player.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def player_params
      params.require(:player).permit(:name, :server_name, :class_name, :spec_name)
    end
end
