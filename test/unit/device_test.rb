require 'test_helper'

class DeviceTest < ActiveSupport::TestCase
  
  test "factory is valid" do
    assert Factory.build(:device).valid?
  end
  
  test "factory needs guid" do
    assert Factory.build(:device, :guid => nil).invalid?
    assert Factory.build(:device, :guid => "   ").invalid?
  end
  
end
