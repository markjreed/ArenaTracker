require 'test_helper'

class ReportsControllerTest < ActionController::TestCase
  test "should get vsspec" do
    get :vsspec
    assert_response :success
  end

end
