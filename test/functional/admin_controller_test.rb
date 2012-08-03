require 'test_helper'

class AdminControllerTest < ActionController::TestCase
  test "should get stats" do
    get :stats
    assert_response :success
  end

end
