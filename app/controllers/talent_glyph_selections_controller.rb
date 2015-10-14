class TalentGlyphSelectionsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :set_talent_glyph_selection, only: [:show, :edit, :update, :destroy]

  # GET /talent_glyph_selections
  # GET /talent_glyph_selections.json
  def index
    @talent_glyph_selections = TalentGlyphSelection.all
  end

  # GET /talent_glyph_selections/1
  # GET /talent_glyph_selections/1.json
  def show
  end

  # GET /talent_glyph_selections/new
  def new
    @talent_glyph_selection = TalentGlyphSelection.new
  end

  # GET /talent_glyph_selections/1/edit
  def edit
  end

  # POST /talent_glyph_selections
  # POST /talent_glyph_selections.json
  def create
    @talent_glyph_selection = TalentGlyphSelection.new(talent_glyph_selection_params)

    respond_to do |format|
      if @talent_glyph_selection.save
        format.html { redirect_to @talent_glyph_selection, notice: 'Talent glyph selection was successfully created.' }
        format.json { render :show, status: :created, location: @talent_glyph_selection }
      else
        format.html { render :new }
        format.json { render json: @talent_glyph_selection.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /talent_glyph_selections/1
  # PATCH/PUT /talent_glyph_selections/1.json
  def update
    respond_to do |format|
      if @talent_glyph_selection.update(talent_glyph_selection_params)
        format.html { redirect_to @talent_glyph_selection, notice: 'Talent glyph selection was successfully updated.' }
        format.json { render :show, status: :ok, location: @talent_glyph_selection }
      else
        format.html { render :edit }
        format.json { render json: @talent_glyph_selection.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /talent_glyph_selections/1
  # DELETE /talent_glyph_selections/1.json
  def destroy
    @talent_glyph_selection.destroy
    respond_to do |format|
      format.html { redirect_to talent_glyph_selections_url, notice: 'Talent glyph selection was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_talent_glyph_selection
      @talent_glyph_selection = TalentGlyphSelection.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def talent_glyph_selection_params
      params.require(:talent_glyph_selection).permit(:tal01, :tal02, :tal03, :tal04, :tal05, :tal06, :tal07, :tal08, :gly01, :gly02, :gly03, :gly04, :gly05, :gly06, :gly07, :gly08, :gly09, :gly10)
    end
end
