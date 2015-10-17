require 'builder'
require 'will_paginate'

class PlayersController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :set_player, only: [:show, :edit, :update, :destroy]

  # GET /players
  # GET /players.json
  def index
    # @players = Player.all
   @filterrific = initialize_filterrific(
      Player,
      params[:filterrific],
      select_options: {
        sorted_by: Player.options_for_sorted_by,
        with_class_name: Player.options_for_select
      },
      persistence_id: 'shared_key',
      default_filter_params: {},
      available_filters: [],
    ) or return
    # Get an ActiveRecord::Relation for all students that match the filter settings.
    # You can paginate with will_paginate or kaminari.
    # NOTE: filterrific_find returns an ActiveRecord Relation that can be
    # chained with other scopes to further narrow down the scope of the list,
    # e.g., to apply permissions or to hard coded exclude certain types of records.
    @players = @filterrific.find.page(params[:page])


    respond_to do |format|
      format.html
      format.js
    end
  end

  def list
  end

  def reset_filterrific
    # Clear session persistence
    session[:filterrific_players] = nil
    # Redirect back to the index action for default filter settings.
    redirect_to action: :index
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
