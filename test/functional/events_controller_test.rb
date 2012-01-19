require 'test_helper'

class EventsControllerTest < ActionController::TestCase\
  
  test "can get event by exact gps coordinates" do
    event = Factory :event, latitude: -41.244772, longitude: 172.617188
    xhr :get, :index, latitude: -41.244772, longitude: 172.617188
    
    assert_response :success
    
    json = JSON.parse(@response.body)
    
    assert_equal 1, json.length
    assert_equal event.id, json[0]["id"]
  end
  
  test "can get event by gps coordinates within a radius" do
    event = Factory :event, latitude: -41.244772, longitude: 172.617188
    xhr :get, :index, latitude: -41.244772, longitude: 172.617188
    
    assert_response :success
    
    json = JSON.parse(@response.body)
    
    assert_equal 1, json.length
    assert_equal event.id, json[0]["id"]
  end
  
  test "can't get event by gps coordinates outside a radius" do
    event = Factory :event, latitude: -41.244772, longitude: 172.617188
    xhr :get, :index, latitude: -41.271098, longitude: 174.781923
    
    assert_response :success
    
    json = JSON.parse(@response.body)
    
    assert_equal 0, json.length
  end
  
  test "can get event by code" do
    event = Factory :event
    
    xhr :get, :index, code: event.code
    assert_response :success
    json = JSON.parse(@response.body)
    
    assert_equal event.id, json["id"]
  end
  
  test "invalid code returns empty json" do
    xhr :get, :index, code: "zoobop"
    assert_response :success
    json = JSON.parse(@response.body)
    
    assert_equal 0, json.length
  end
    
end
