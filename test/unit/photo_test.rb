require 'test_helper'

class PhotoTest < ActiveSupport::TestCase
  
  test "factory is valid" do
    assert Factory.build(:photo).valid?
  end
  
  test "photo needs to belong to an event" do
    assert Factory.build(:photo, event: nil).invalid?
    assert Factory.build(:photo, event_id: 100).invalid?
  end
  
  test "photo doesn't need to belong to a device" do
    assert Factory.build(:photo, device_id: nil).valid?
  end
  
end
