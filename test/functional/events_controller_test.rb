require 'test_helper'

class EventsControllerTest < ActionController::TestCase

  def setup
    @user = Factory(:user)
    @event = Factory(:event)
    @stub = stub(:deliver)
  end
  
  test "new and create redirect if not signed in" do
    get :new
    assert_redirected_to new_user_session_path
    
    post :create, event: @event.attributes.slice(:location, :name, :latitude, :longitude, :starts, :ends, :code, :is_public)
    assert_redirected_to new_user_session_path
  end
  
  test "can get new if signed in" do
    sign_in @user
    get :new
    assert_select "input#event_location"
    assert_select "input#event_name"
    assert_select "input#event_code"
  end
  
  test "can post new event if signed in" do
    sign_in @user
    
    assert_difference "Attendee.count" do
      assert_difference "Event.count" do
        post :create, event: @event.attributes.slice(:location, :name, :latitude, :longitude, :starts, :ends, :code, :is_public)
      end
    end
    
    event = Event.last
    attendee = Attendee.between(@user, event)
    assert_redirected_to event_photos_path event
    assert attendee
    assert attendee.is_admin?, "Attendee should be an admin"
  end
  
  test "first event sends welcome email" do
    sign_in @user
    
    Notifier.expects(:welcome).once.returns(@stub)
    post :create, event: @event.attributes.slice(:location, :name, :latitude, :longitude, :starts, :ends, :code, :is_public)
  
    
    Notifier.expects(:welcome).never
    post :create, event: @event.attributes.slice(:location, :name, :latitude, :longitude, :starts, :ends, :code, :is_public)
  end
  
  test "if landing_page is in session, price is different" do
    #emulate the session being set on a landing page
    LandingPage.create do |l|
      l.price = 49*100
      l.path = "test"
    end
    sign_in @user
    session["landing_page"] = "test"
    
    get :new
    assert_select "button[type=submit] span#price", "USD$49", "Price should be $49"
  end
  
  test "if landing_page is not in session, price is 199" do
    sign_in @user
    get :new
    assert_select "button[type=submit] span#price", "USD$199"
  end
  
  test "landing_page details are set on an event if present" do
    #emulate the session being set on a landing page
    lp = LandingPage.create do |l|
      l.price = 49*100
      l.path = "test"
    end
    sign_in @user
    session["landing_page"] = "test"
    
    post :create, event: @event.attributes.slice(:location, :name, :latitude, :longitude, :starts, :ends, :code, :is_public)
    e = Event.last
    assert_equal lp, e.landing_page
  end
  
  test "can't pass landing_page details as params" do
    lp = LandingPage.create do |l|
      l.price = 49*100
      l.path = "test"
    end
    sign_in @user
    
    assert_raises ActiveModel::MassAssignmentSecurity::Error do
      post :create, event: @event.attributes.slice(:location, :name, :latitude, :longitude, :starts, :ends, :code, :is_public).merge(landing_page_id: lp.id)
    end
  end
  
  test "can edit event if admin" do
    Attendee.create do |at|
      at.event = @event
      at.user = @user
      at.is_admin = true
    end
    sign_in @user
    get :edit, id: @event.to_param
    assert_response :success
    assert_equal @event, assigns(:event)
  end
  
  test "can't edit event if not admin" do
    Attendee.create do |at|
      at.event = @event
      at.user = @user
    end
    sign_in @user
    get :edit, id: @event.to_param
    assert_response :not_found
  end
  
end
class EventsAPIControllerTest < ActionController::TestCase
  tests EventsController
  
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
