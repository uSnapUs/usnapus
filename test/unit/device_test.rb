require 'test_helper'

class DeviceTest < ActiveSupport::TestCase
  
  test "factory is valid" do
    assert Factory.build(:device).valid?
  end
  
  test "factory needs guid" do
    assert Factory.build(:device, :guid => nil).invalid?
    assert Factory.build(:device, :guid => "   ").invalid?
  end
  
  test "factory needs name" do
    assert Factory.build(:device, :name => nil).invalid?
    assert Factory.build(:device, :name => "   ").invalid?
  end
  
  test "device can have photos" do
    device = Factory :device
    photo = Factory :photo, creator: device 
    
    assert_equal 1, device.photos.size
    assert device.photos.include? photo
  end
  
  test "device can't update guid" do
    device = Factory :device
    orig_g = device.guid
    
    device.guid = "123"
    assert device.invalid?
  end
    
end
