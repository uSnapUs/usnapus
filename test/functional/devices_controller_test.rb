require 'test_helper'

class DevicesControllerTest < ActionController::TestCase
  setup do
    @device = Factory(:device)
  end
  
  test "should create device" do
    assert_difference('Device.count') do
      xhr :post, :create, device: @device.attributes
    end

    assert_response :success
  end
  
  test "shouldn't create device without guid" do
    assert_no_difference "Device.count" do
      xhr :post, :create, device: @device.attributes.merge(guid: nil)
    end
    assert_response :unprocessable_entity
    
    json = JSON.parse(@response.body)
    assert_equal ["can't be blank"], json["guid"]
  end
  
  
end
