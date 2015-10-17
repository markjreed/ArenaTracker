require 'test_helper'

class MatchTalentGlyphSelectionsControllerTest < ActionController::TestCase
  setup do
    @match_talent_glyph_selection = match_talent_glyph_selections(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:match_talent_glyph_selections)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create match_talent_glyph_selection" do
    assert_difference('MatchTalentGlyphSelection.count') do
      post :create, match_talent_glyph_selection: { Match_id: @match_talent_glyph_selection.Match_id, Player_id: @match_talent_glyph_selection.Player_id, talent_glyph_selection_id: @match_talent_glyph_selection.talent_glyph_selection_id }
    end

    assert_redirected_to match_talent_glyph_selection_path(assigns(:match_talent_glyph_selection))
  end

  test "should show match_talent_glyph_selection" do
    get :show, id: @match_talent_glyph_selection
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @match_talent_glyph_selection
    assert_response :success
  end

  test "should update match_talent_glyph_selection" do
    patch :update, id: @match_talent_glyph_selection, match_talent_glyph_selection: { Match_id: @match_talent_glyph_selection.Match_id, Player_id: @match_talent_glyph_selection.Player_id, talent_glyph_selection_id: @match_talent_glyph_selection.talent_glyph_selection_id }
    assert_redirected_to match_talent_glyph_selection_path(assigns(:match_talent_glyph_selection))
  end

  test "should destroy match_talent_glyph_selection" do
    assert_difference('MatchTalentGlyphSelection.count', -1) do
      delete :destroy, id: @match_talent_glyph_selection
    end

    assert_redirected_to match_talent_glyph_selections_path
  end
end
