require 'test_helper'
 
class EventTest < ActionDispatch::IntegrationTest
  
  test "can get event by code" do
    event = Factory(:event)
    event.update_attributes(code: "NICK")
    
    get "/nick"
    assert_redirected_to event_photos_path(event)
    follow_redirect!
    assert_equal event, assigns(:event)
    assert_equal event, assigns(:event)
    
    get "/NICK"
    assert_redirected_to event_photos_path(event)
    follow_redirect!
    assert_equal event, assigns(:event)
  end
  
end