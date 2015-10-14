class MatchTalentGlyphSelectionsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :set_match_talent_glyph_selection, only: [:show, :edit, :update, :destroy]

  # GET /match_talent_glyph_selections
  # GET /match_talent_glyph_selections.json
  def index
    @match_talent_glyph_selections = MatchTalentGlyphSelection.all
  end

  # GET /match_talent_glyph_selections/1
  # GET /match_talent_glyph_selections/1.json
  def show
  end

  # GET /match_talent_glyph_selections/new
  def new
    @match_talent_glyph_selection = MatchTalentGlyphSelection.new
  end

  # GET /match_talent_glyph_selections/1/edit
  def edit
  end

  # POST /match_talent_glyph_selections
  # POST /match_talent_glyph_selections.json
  def create
    @match_talent_glyph_selection = MatchTalentGlyphSelection.new(match_talent_glyph_selection_params)

    respond_to do |format|
      if @match_talent_glyph_selection.save
        format.html { redirect_to @match_talent_glyph_selection, notice: 'Match talent glyph selection was successfully created.' }
        format.json { render :show, status: :created, location: @match_talent_glyph_selection }
      else
        format.html { render :new }
        format.json { render json: @match_talent_glyph_selection.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /match_talent_glyph_selections/1
  # PATCH/PUT /match_talent_glyph_selections/1.json
  def update
    respond_to do |format|
      if @match_talent_glyph_selection.update(match_talent_glyph_selection_params)
        format.html { redirect_to @match_talent_glyph_selection, notice: 'Match talent glyph selection was successfully updated.' }
        format.json { render :show, status: :ok, location: @match_talent_glyph_selection }
      else
        format.html { render :edit }
        format.json { render json: @match_talent_glyph_selection.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /match_talent_glyph_selections/1
  # DELETE /match_talent_glyph_selections/1.json
  def destroy
    @match_talent_glyph_selection.destroy
    respond_to do |format|
      format.html { redirect_to match_talent_glyph_selections_url, notice: 'Match talent glyph selection was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_match_talent_glyph_selection
      @match_talent_glyph_selection = MatchTalentGlyphSelection.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def match_talent_glyph_selection_params
      params.require(:match_talent_glyph_selection).permit(:Player_id, :Match_id, :TalentGlyphSelection_id)
    end
end
