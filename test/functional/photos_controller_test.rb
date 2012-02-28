require 'test_helper'

class PhotosControllerTest < ActionController::TestCase
  
  setup do
    @photo = Factory(:photo)
    @event = @photo.event
  end
  
  teardown do
    FileUtils.rm_rf "#{Rails.root}/public/events/"
  end

  test "should create photo" do
    assert_difference 'Photo.count' do
      xhr :post, :create, event_id: @event.to_param, photo: unprotected_attributes(@photo), format: "json"
    end
    assert_response :success
    json = JSON.parse(@response.body)
    assert_equal Photo.last.id, json["id"]
  end
  
  test "should create photo with test file" do
    assert_difference 'Photo.count' do
      xhr :post, :create, 
        event_id: @event.to_param, 
        photo: unprotected_attributes(@photo).merge(photo: fixture_file_upload('files/house.jpg','image/jpg')),
        format: "json"
    end
    assert_response :success
    
    photo = Photo.last
    assert File.exists?("#{Rails.root}/public/events/#{@event.s3_token}/photos/#{photo.id}/house.jpg"), "Original version should be stored"
    assert File.exists?("#{Rails.root}/public/events/#{@event.s3_token}/photos/#{photo.id}/thumbnail_house.jpg"), "Thumbnail version should be created"
  end
  
  
  test "creating a photo should fire a Pusher event" do
    Pusher["event-#{@event.id}-photocast"].expects(:trigger!).once
    xhr :post, :create, event_id: @event.to_param, photo: unprotected_attributes(@photo), format: "json"
  end
  
  test "should be able to delete photo" do
    assert_difference 'Photo.count', -1 do
      xhr :delete, :destroy, event_id: @event.to_param, id: @photo.id, format: "json"
    end
    assert_response :success
  end
  
  
  test "can view photos with event id" do
    get :index, event_id: @event.to_param
    assert_response :success
    assert assigns(:photos)
  end
  
  test "photos are returned most recent first" do
    
    @photo.created_at = 3.seconds.ago
    @photo.save!
    
    photo2 = Factory(:photo, event: @photo.event)
    xhr :get, :index, event_id: @event.to_param, format: "json"
    json = JSON.parse(@response.body)
    assert_equal photo2.id, json[0]["id"]
    assert_equal @photo.id, json[1]["id"]
  end
  
  test "can limit photos" do
    photo2 = Factory(:photo, event: @photo.event)
    xhr :get, :index, event_id: @event.to_param, limit: 1, format: "json"
    json = JSON.parse(@response.body)
    assert_equal 1, json.length
  end
  
  
  test "can't see event's photos if it isn't public" do
    event = Factory :current_event, is_public: false
    assert_raises ActiveRecord::RecordNotFound do
      get :index, :event_id => event.id
    end
  end
  
end
