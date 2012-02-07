require 'test_helper'

class EventsControllerTest < ActionController::TestCase\
  
  test "can get event by exact gps coordinates" do
    event = Factory :current_event, latitude: -41.244772, longitude: 172.617188
    xhr :get, :index, latitude: -41.244772, longitude: 172.617188
    
    assert_response :success
    
    json = JSON.parse(@response.body)
    
    assert_equal 1, json.length
    assert_equal event.id, json[0]["id"]
  end
  
  test "can get event by gps coordinates within a radius" do
    event = Factory :current_event, latitude: -41.244772, longitude: 172.617188
    xhr :get, :index, latitude: -41.244772, longitude: 172.617188
    
    assert_response :success
    
    json = JSON.parse(@response.body)
    
    assert_equal 1, json.length
    assert_equal event.id, json[0]["id"]
  end
  
  test "can't get event by gps coordinates outside a radius" do
    event = Factory :current_event, latitude: -41.244772, longitude: 172.617188
    xhr :get, :index, latitude: -41.271098, longitude: 174.781923
    
    assert_response :success
    
    json = JSON.parse(@response.body)
    
    assert_equal 0, json.length
  end
    
  test "can get event by code" do
    event = Factory :current_event
    
    xhr :get, :index, code: event.code
    assert_response :success
    json = JSON.parse(@response.body)
    
    assert_equal event.id, json[0]["id"]
  end
  
  test "invalid code returns empty json" do
    xhr :get, :index, code: "zoobop"
    assert_response :success
    json = JSON.parse(@response.body)
    
    assert_equal [], json
  end
  
  
  test "can see an event now" do
    xhr :get, :index, code: Factory(:current_event).code
    assert_equal 1, JSON.parse(@response.body).length
  end
  
  test "can't see event which hasn't started by GPS" do
    event = Factory :current_event, starts: 1.minute.from_now, latitude: -41.244772, longitude: 172.617188
    xhr :get, :index, latitude: event.latitude, longitude: event.longitude
    assert_equal 0, JSON.parse(@response.body).length
  end
  
  test "can see event which hasn't started by code" do
    event = Factory :current_event, starts: 1.minute.from_now
    xhr :get, :index, code: event.code
    assert_equal 1, JSON.parse(@response.body).length
  end
  
  test "can't see event which has finished by GPS" do
    event = Factory :current_event, ends: 1.minute.ago, latitude: -41.244772, longitude: 172.617188
    xhr :get, :index, latitude: event.latitude, longitude: event.longitude
    assert_equal 0, JSON.parse(@response.body).length
  end
  
  
  test "can see event which has finished by code" do
    event = Factory :current_event, ends: 1.minute.ago, latitude: -41.244772, longitude: 172.617188
    xhr :get, :index, code: event.code
    assert_equal 1, JSON.parse(@response.body).length
  end
    
end
