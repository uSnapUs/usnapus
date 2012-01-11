require 'test_helper'

class SignupsControllerTest < ActionController::TestCase
  
  test "should create signup" do
    assert_difference('Signup.count') do
      xhr :post, :create, signup: {email: "test@example.com"}
    end

    assert_response :success
  end
end
