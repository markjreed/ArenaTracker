require 'test_helper'

class PersonalMatchInfosControllerTest < ActionController::TestCase
  setup do
    @personal_match_info = personal_match_infos(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:personal_match_infos)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create personal_match_info" do
    assert_difference('PersonalMatchInfo.count') do
      post :create, personal_match_info: { fight_number: @personal_match_info.fight_number, glyphs: @personal_match_info.glyphs, match_id: @personal_match_info.match_id, note: @personal_match_info.note, player_id: @personal_match_info.player_id, talents: @personal_match_info.talents, winner: @personal_match_info.winner }
    end

    assert_redirected_to personal_match_info_path(assigns(:personal_match_info))
  end

  test "should show personal_match_info" do
    get :show, id: @personal_match_info
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @personal_match_info
    assert_response :success
  end

  test "should update personal_match_info" do
    patch :update, id: @personal_match_info, personal_match_info: { fight_number: @personal_match_info.fight_number, glyphs: @personal_match_info.glyphs, match_id: @personal_match_info.match_id, note: @personal_match_info.note, player_id: @personal_match_info.player_id, talents: @personal_match_info.talents, winner: @personal_match_info.winner }
    assert_redirected_to personal_match_info_path(assigns(:personal_match_info))
  end

  test "should destroy personal_match_info" do
    assert_difference('PersonalMatchInfo.count', -1) do
      delete :destroy, id: @personal_match_info
    end

    assert_redirected_to personal_match_infos_path
  end
end
