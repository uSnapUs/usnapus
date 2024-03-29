require 'test_helper'

class DevicesControllerTest < ActionController::TestCase
  setup do
    @device = Factory(:device)
  end
  
  test "should create device" do
    assert_difference('Device.count') do
      xhr :post, :create, device: @device.attributes.slice("guid", "name")
    end

    assert_response :success
  end
  
  test "shouldn't create device without guid" do
    assert_no_difference "Device.count" do
      xhr :post, :create, device: @device.attributes.slice("name", "email").merge(guid: nil)
    end
    assert_response :unprocessable_entity
    
    json = JSON.parse(@response.body)
    assert_equal ["can't be blank"], json["guid"]
  end
  
  test "shouldn't create device with blank name" do
    assert_no_difference "Device.count" do
      xhr :post, :create, device: @device.attributes.slice("guid", "email").merge(name: "   ")
    end
    assert_response :unprocessable_entity
    
    json = JSON.parse(@response.body)
    assert_equal ["can't be blank"], json["name"]
  end
  
  test "should update device name" do
    xhr :put, :update, id: @device.to_param, device: @device.attributes.slice("guid", "email").merge(name: "Xavier")
    assert_response :success
    
    assert_equal "Xavier", @device.reload.name
  end
  
  test "shouldn't update device to blank name" do
    
    xhr :put, :update, id: @device.to_param, device: @device.attributes.slice("guid", "email").merge(name: "   ")
    assert_response :unprocessable_entity
    
    json = JSON.parse(@response.body)
    assert_equal ["can't be blank"], json["name"]
  end
  
  test "shouldn't update guid" do
    old_guid = @device.guid
    
    xhr :put, :update, id: @device.to_param, device: @device.attributes.slice("name", "email").merge(guid: "asdae214")
    assert_response :unprocessable_entity
    
    json = JSON.parse(@response.body)
    assert_equal ["can't be changed"], json["guid"]
  end
  
  test "should update device email" do
    xhr :put, :update, id: @device.to_param, device: @device.attributes.slice("guid", "name").merge(email: "awesome@example.com")
    assert_response :success
    
    assert_equal "awesome@example.com", @device.reload.email
  end
  
end
