require 'test_helper'
 
class EventTest < ActionDispatch::IntegrationTest
  
  test "can get public event by code" do
    event = Factory(:event, is_public: true)
    event.update_attributes(code: "NICK")
    
    get "/nick"
    assert_response :success
    assert_equal event, assigns(:event)
    assert_equal event.photos, assigns(:photos)
    
    get "/NICK"
    assert_response :success
    assert_equal event, assigns(:event)
    assert_equal event.photos, assigns(:photos)
  end
  
  test "can't get private event by code" do
    event = Factory(:event, is_public: false)
    event.update_attributes(code: "NICK")
    
    get "/nick"
    assert_response :not_found
    
    get "/NICK"
    assert_response :not_found
  end
  
end