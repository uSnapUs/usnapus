require 'test_helper'

class PhotoTest < ActiveSupport::TestCase
  
  test "factory is valid" do
    assert Factory.build(:photo).valid?
  end
  
  test "photo needs to belong to an event" do
    assert Factory.build(:photo, event: nil).invalid?
  end
  
  test "photo needs to belong to a device" do
    assert Factory.build(:photo, device: nil).invalid?
  end
  
end
