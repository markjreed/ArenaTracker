require 'test_helper'

class RawBattlesControllerTest < ActionController::TestCase
  setup do
    @raw_battle = raw_battles(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:raw_battles)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create raw_battle" do
    assert_difference('RawBattle.count') do
      post :create, raw_battle: { parse_status: @raw_battle.parse_status, raw_battle_data: @raw_battle.raw_battle_data, status_message: @raw_battle.status_message }
    end

    assert_redirected_to raw_battle_path(assigns(:raw_battle))
  end

  test "should show raw_battle" do
    get :show, id: @raw_battle
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @raw_battle
    assert_response :success
  end

  test "should update raw_battle" do
    patch :update, id: @raw_battle, raw_battle: { parse_status: @raw_battle.parse_status, raw_battle_data: @raw_battle.raw_battle_data, status_message: @raw_battle.status_message }
    assert_redirected_to raw_battle_path(assigns(:raw_battle))
  end

  test "should destroy raw_battle" do
    assert_difference('RawBattle.count', -1) do
      delete :destroy, id: @raw_battle
    end

    assert_redirected_to raw_battles_path
  end
end
