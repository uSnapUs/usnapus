require 'test_helper'

class PhotosControllerTest < ActionController::TestCase
  setup do
    @photo = Factory(:photo)
    @event = @photo.event
  end

  test "should create photo" do
    assert_difference 'Photo.count' do
      xhr :post, :create, event_id: @event.to_param, photo: @photo.attributes
    end
    assert_response :success
    json = JSON.parse(@response.body)
    assert_equal Photo.last.id, json["id"]
  end
  
  
  test "should not create photo without real event" do
    assert_no_difference 'Photo.count' do
      assert_raises ActiveRecord::RecordNotFound do
        xhr :post, :create, event_id: 100, photo: @photo.attributes
      end
    end
  end
  
  test "event photo attribute should not override event path param" do
    assert_difference 'Photo.count' do
      xhr :post, :create, event_id: @event, photo: @photo.attributes.merge(event_id: Factory(:event).id )
    end
    assert_response :success
    
    assert_equal @event, Photo.last.event
  end
  
  
  
  test "should not create photo without device id" do
    assert_no_difference 'Photo.count' do
      xhr :post, :create, event_id: @event.to_param, photo: @photo.attributes.merge(device_id: nil)
    end
    assert_response :unprocessable_entity
    json = JSON.parse(@response.body)
    assert_equal ["can't be blank"], json["device_id"]
  end
  
  test "should not create photo without real device" do
    assert_no_difference 'Photo.count' do
      xhr :post, :create, event_id: @event.to_param, photo: @photo.attributes.merge(device_id: 100)
    end
    assert_response :unprocessable_entity
    json = JSON.parse(@response.body)
    assert_equal ["must point to an existing device"], json["device_id"]
  end
  
  
  
  test "should be able to delete photo" do
    assert_difference 'Photo.count', -1 do
      xhr :delete, :destroy, event_id: @event.to_param, id: @photo.id
    end
    assert_response :success
  end
  
  
  
  test "can view slideshow with event id" do
    get :index, event_id: @event.to_param
     
    assert_response :success
  end
  
end
