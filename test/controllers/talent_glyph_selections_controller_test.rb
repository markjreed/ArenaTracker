require 'test_helper'

class TalentGlyphSelectionsControllerTest < ActionController::TestCase
  setup do
    @talent_glyph_selection = talent_glyph_selections(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:talent_glyph_selections)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create talent_glyph_selection" do
    assert_difference('TalentGlyphSelection.count') do
      post :create, talent_glyph_selection: { gly01: @talent_glyph_selection.gly01, gly02: @talent_glyph_selection.gly02, gly03: @talent_glyph_selection.gly03, gly04: @talent_glyph_selection.gly04, gly05: @talent_glyph_selection.gly05, gly06: @talent_glyph_selection.gly06, gly07: @talent_glyph_selection.gly07, gly08: @talent_glyph_selection.gly08, gly09: @talent_glyph_selection.gly09, gly10: @talent_glyph_selection.gly10, tal01: @talent_glyph_selection.tal01, tal02: @talent_glyph_selection.tal02, tal03: @talent_glyph_selection.tal03, tal04: @talent_glyph_selection.tal04, tal05: @talent_glyph_selection.tal05, tal06: @talent_glyph_selection.tal06, tal07: @talent_glyph_selection.tal07, tal08: @talent_glyph_selection.tal08 }
    end

    assert_redirected_to talent_glyph_selection_path(assigns(:talent_glyph_selection))
  end

  test "should show talent_glyph_selection" do
    get :show, id: @talent_glyph_selection
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @talent_glyph_selection
    assert_response :success
  end

  test "should update talent_glyph_selection" do
    patch :update, id: @talent_glyph_selection, talent_glyph_selection: { gly01: @talent_glyph_selection.gly01, gly02: @talent_glyph_selection.gly02, gly03: @talent_glyph_selection.gly03, gly04: @talent_glyph_selection.gly04, gly05: @talent_glyph_selection.gly05, gly06: @talent_glyph_selection.gly06, gly07: @talent_glyph_selection.gly07, gly08: @talent_glyph_selection.gly08, gly09: @talent_glyph_selection.gly09, gly10: @talent_glyph_selection.gly10, tal01: @talent_glyph_selection.tal01, tal02: @talent_glyph_selection.tal02, tal03: @talent_glyph_selection.tal03, tal04: @talent_glyph_selection.tal04, tal05: @talent_glyph_selection.tal05, tal06: @talent_glyph_selection.tal06, tal07: @talent_glyph_selection.tal07, tal08: @talent_glyph_selection.tal08 }
    assert_redirected_to talent_glyph_selection_path(assigns(:talent_glyph_selection))
  end

  test "should destroy talent_glyph_selection" do
    assert_difference('TalentGlyphSelection.count', -1) do
      delete :destroy, id: @talent_glyph_selection
    end

    assert_redirected_to talent_glyph_selections_path
  end
end
