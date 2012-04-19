require 'test_helper'

class RegistrationsControllerTest < ActionController::TestCase
  
  setup do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end
  
  test "new registration should go to new event page" do
    assert_difference "User.count" do
      post :create, user: {name: "Nick", email: "nick@example.com", password: "secret"}
    end
    assert_redirected_to new_event_path
  end
  
  test "can edit account" do
    user = Factory(:user)
    sign_in user
    get :edit, id: user.to_param
    assert_response :success
  end
  
end