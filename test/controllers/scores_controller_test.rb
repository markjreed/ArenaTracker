require 'test_helper'

class ScoresControllerTest < ActionController::TestCase
  setup do
    @score = scores(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:scores)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create score" do
    assert_difference('Score.count') do
      post :create, score: { Match_id: @score.Match_id, Player_id: @score.Player_id, damage_done: @score.damage_done, healing_done: @score.healing_done, killing_blows: @score.killing_blows, player_faction: @score.player_faction, ratings_adjustment: @score.ratings_adjustment }
    end

    assert_redirected_to score_path(assigns(:score))
  end

  test "should show score" do
    get :show, id: @score
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @score
    assert_response :success
  end

  test "should update score" do
    patch :update, id: @score, score: { Match_id: @score.Match_id, Player_id: @score.Player_id, damage_done: @score.damage_done, healing_done: @score.healing_done, killing_blows: @score.killing_blows, player_faction: @score.player_faction, ratings_adjustment: @score.ratings_adjustment }
    assert_redirected_to score_path(assigns(:score))
  end

  test "should destroy score" do
    assert_difference('Score.count', -1) do
      delete :destroy, id: @score
    end

    assert_redirected_to scores_path
  end
end
