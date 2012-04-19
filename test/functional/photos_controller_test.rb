require 'test_helper'

class PhotosControllerTest < ActionController::TestCase
  
  setup do
    @user = Factory(:user)
    @event = Factory(:current_event, is_public: true)
    @attendee = Factory(:attendee, user: @user, event: @event)
    @photo = Factory(:processed_photo, event: @event)
    
    sign_in @user
  end
  
  teardown do
    FileUtils.rm_rf "#{Rails.root}/public/uploads/"
  end
  
  test "can view photos with event id" do
    get :index, event_id: @event.to_param
    assert_response :success
    assert_equal [@photo], assigns(:photos)
    assert_select "#photo_gallery", 1
    assert_select ".settings li a[href=#{destroy_user_session_path}]"
  end

  test "can view settings button if admin" do
    @attendee.is_admin = true
    @attendee.save!
    
    get :index, event_id: @event.to_param
    assert_select ".settings li a[href=#{destroy_user_session_path}]"
  end

  test "can get private event by id" do
    @event.update_attributes is_public: false
    get :index, event_id: @event.to_param
    assert_response :success
    assert_equal [@photo], assigns(:photos)
    assert_select "#photo_gallery", 1
  end
  
  test "can get private event by code" do
    @event.update_attributes is_public: false
    get :index, event_id: @event.to_param
    assert_response :success
    assert_equal [@photo], assigns(:photos)
    assert_select "#photo_gallery", 1
  end
  
  test "can watch slideshow" do
    get :fullscreen, event_id: @event.to_param
    assert_response :success
    get :fullscreen, code: @event.code
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
  
  test "can upload photos" do
    PhotoUploader.enable_processing = true
    Resque.stubs(:enqueue)
    Resque.expects(:enqueue).with(::CarrierWave::Workers::ProcessAsset, "Photo", Photo.last.id+1, :photo).once
    assert_difference "Photo.count" do
      post :create, 
        event_id: @event.to_param, 
        photo: {photo: fixture_file_upload('files/house.jpg','image/jpg')}
    end
    PhotoUploader.enable_processing = false
    
    photo = Photo.last
    assert_equal @event, photo.event
    assert_equal @user, photo.creator
  end
  
  test "shouldn't be able to delete another creator's photo" do
    assert_no_difference 'Photo.count' do
      xhr :delete, :destroy, event_id: @event.to_param, id: @photo.id, format: "json"
      assert_response :not_found
    end
  end
  
  test "should be able to delete a user's own photo" do
    photo_id = Factory(:photo, creator: @user, event: @event).id
    
    assert_difference 'Photo.count', -1 do
      xhr :delete, :destroy, event_id: @event.to_param, id: photo_id, format: "json"
    end
    
    assert_response :success
    assert_nil Photo.find_by_id(photo_id)
  end
   
  test "should be able to delete another creator's photo if admin" do
    photo_id = @photo.id
    
    @attendee.is_admin = true
    @attendee.save!
    
    assert_difference 'Photo.count', -1 do
      xhr :delete, :destroy, event_id: @event.to_param, id: photo_id, format: "json"
      assert_response :success
    end
    
    assert_nil Photo.find_by_id(photo_id)
  end
  
  test "admin should be able to request photo download" do
    @attendee.is_admin = true
    @attendee.save!
    
    assert_difference "ActionMailer::Base.deliveries.count" do
      xhr :get, :download, event_id: @event.to_param
      assert_response :success
    end
  end
  
  test "non-admin shouldn't be able to request photo download" do
    assert_no_difference "ActionMailer::Base.deliveries.count" do
      xhr :get, :download, event_id: @event.to_param
      assert_response :not_found
    end
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
    assert_raises ActiveRecord::RecordNotFound do
      xhr :post, :create, 
        event_id: @event.to_param, 
        photo: {photo: fixture_file_upload('files/house.jpg','image/jpg')},
        format: "json"
    end
    
    assert_raises ActiveRecord::RecordNotFound do
      xhr :delete, :destroy, event_id: @event.to_param, id: @photo.id, format: "json"
    end
  end
  
  test "can't get public event by id" do
    @event.update_attributes is_public: true
    assert_raises ActiveRecord::RecordNotFound do
      get :index, event_id: @event.to_param
    end
  end
  
  test "can get public event by code" do
    @event.update_attributes is_public: true
    get :index, code: @event.code
    assert_response :success
  end
  
  test "can watch slideshow" do
    get :fullscreen, code: @event.code
    assert_response :success
  end
  
  test "can get public event json by code" do
    @event.update_attributes is_public: true
    xhr :get, :index, code: @event.code, format: "json"
    assert_response :success
    json = JSON.parse(@response.body)
    assert_equal @photo.id, json[0]["id"]
  end
  
  test "can't get private event by code" do
    @event.update_attributes is_public: false
    assert_raises ActiveRecord::RecordNotFound do
      get :index, code: @event.code
    end
  end

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
    @request.env["Authorization"] = "Device token=#{@device.guid}"
    
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
    
    assert_equal @device, Photo.last.creator
  end
  
  
  test "shouldn't be able to delete another creator's photo with device auth" do
    @request.env["Authorization"] = "Device token=#{@device.guid}"
    
    assert_no_difference 'Photo.count' do
      xhr :delete, :destroy, event_id: @event.to_param, id: @photo.id, format: "json"
      assert_response :not_found
    end
  end
  
  test "should be able to delete a device's photo with device auth" do
    photo_id = Factory(:photo, creator: @device, event: @event).id
    
    @request.env["Authorization"] = "Device token=#{@device.guid}"
    
    assert_difference 'Photo.count', -1 do
      xhr :delete, :destroy, event_id: @event.to_param, id: photo_id, format: "json"
    end
    
    assert_response :success
    assert_nil Photo.find_by_id(photo_id)
  end
  
end