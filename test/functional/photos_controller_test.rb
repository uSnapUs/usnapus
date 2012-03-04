require 'test_helper'

class PhotosControllerTest < ActionController::TestCase
  
  setup do
    @user = Factory(:user)
    @event = Factory(:current_event, is_public: true)
    Factory(:attendee, user: @user, event: @event)
    @photo = Factory(:processed_photo, event: @event)
    
    sign_in @user
  end
  
  test "can view photos with event id" do
    get :index, event_id: @event.to_param
    assert_response :success
    assert_equal [@photo], assigns(:photos)
    assert_select "#photo_gallery", 1
  end
  
  test "can watch slideshow" do
    get :fullscreen, event_id: @event.to_param
    assert_response :success
  end
  
  test "photos are returned most recent first" do
    
    @photo.created_at = 3.seconds.ago
    @photo.save!
    
    photo2 = Factory(:processed_photo, event: @photo.event)
    xhr :get, :index, event_id: @event.to_param, format: "json"
    json = JSON.parse(@response.body)
    assert_equal photo2.id, json[0]["id"]
    assert_equal @photo.id, json[1]["id"]
  end
  
  test "photos which haven't finished processing aren't shown" do
    photo = Factory(:photo, event: @photo.event)
    xhr :get, :index, event_id: @event.to_param, format: "json"
    json = JSON.parse(@response.body)
    assert_equal 1, json.length #Contains @photo
    assert_equal @photo.id, json[0]["id"]
  end
  
  test "can limit photos" do
    photo2 = Factory(:processed_photo, event: @photo.event)
    xhr :get, :index, event_id: @event.to_param, limit: 1, format: "json"
    json = JSON.parse(@response.body)
    assert_equal 1, json.length
  end
   
end
class NotSignedInPhotosControllerTest < ActionController::TestCase
  tests PhotosController
  
  setup do
    @event = Factory(:current_event, is_public: true)
    @photo = Factory(:processed_photo, event: @event)
  end

  teardown do
    FileUtils.rm_rf "#{Rails.root}/public/uploads/"
  end
  
  test "create and delete return 404" do
    xhr :post, :create, 
      event_id: @event.to_param, 
      photo: {photo: fixture_file_upload('files/house.jpg','image/jpg')},
      format: "json"
    assert_response :not_found
    
    xhr :delete, :destroy, event_id: @event.to_param, id: @photo.id, format: "json"
    assert_response :not_found
  end
  
  test "can't get event by id if not signed in" do
    @event.update_attributes is_public: false
    get :index, event_id: @event.to_param
    assert_response :not_found
  end
  
  #Event by code in integration tests

end
class APIPhotosControllerTest < ActionController::TestCase
  tests PhotosController

  setup do
    @device = Factory(:device)
    @photo = Factory(:processed_photo)
    @event = @photo.event
  end
  
  teardown do
    FileUtils.rm_rf "#{Rails.root}/public/uploads/"
  end
  
  test "should create photo and start a background job with device auth" do
    @request.env["Authorization"] = "Device token=\"#{@device.guid}\""
    
    PhotoUploader.enable_processing = true
    Resque.stubs(:enqueue)
    Resque.expects(:enqueue).with(::CarrierWave::Workers::ProcessAsset, "Photo", Photo.last.id+1, :photo).once
    assert_difference 'Photo.count' do
      xhr :post, :create, 
        event_id: @event.to_param, 
        photo: {photo: fixture_file_upload('files/house.jpg','image/jpg')},
        format: "json"
    end
    assert_response :success
    
    PhotoUploader.enable_processing = false
    
    assert_equal @device, Photo.last.device
  end
  
  
  test "shouldn't be able to delete another device's photo with device auth" do
    @request.env["Authorization"] = "Device token=\"#{@device.guid}\""
    
    assert_no_difference 'Photo.count' do
      xhr :delete, :destroy, event_id: @event.to_param, id: @photo.id, format: "json"
      assert_response :not_found
    end
  end
  
  test "should be able to delete a device's photo with device auth" do
    photo_id = Factory(:photo, device: @device, event: @event).id
    
    @request.env["Authorization"] = "Device token=\"#{@device.guid}\""
    
    assert_difference 'Photo.count', -1 do
      xhr :delete, :destroy, event_id: @event.to_param, id: photo_id, format: "json"
    end
    
    assert_response :success
    assert_nil Photo.find_by_id(photo_id)
  end
  
  
end