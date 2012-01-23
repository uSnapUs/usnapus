require 'test_helper'

class PhotosControllerTest < ActionController::TestCase
  setup do
    @photo = Factory(:photo)
  end

  test "should create photo" do
    assert_difference 'Photo.count' do
      xhr :post, :create, photo: @photo.attributes
    end
    assert_response :success
    json = JSON.parse(@response.body)
    assert_equal Photo.last.id, json["id"]
  end
  
  test "should not create photo without event id" do
     assert_no_difference 'Photo.count' do
       xhr :post, :create, photo: @photo.attributes.merge(event_id: nil)
     end
     assert_response :unprocessable_entity
     json = JSON.parse(@response.body)
     assert_equal ["can't be blank"], json["event_id"]
   end
  
  test "should not create photo without device id" do
    assert_no_difference 'Photo.count' do
      xhr :post, :create, photo: @photo.attributes.merge(device_id: nil)
    end
    assert_response :unprocessable_entity
    json = JSON.parse(@response.body)
    assert_equal ["can't be blank"], json["device_id"]
  end
  
  test "should be able to delete photo" do
    assert_difference 'Photo.count', -1 do
      xhr :delete, :destroy, id: @photo.id
    end
    assert_response :success
  end
  
end
