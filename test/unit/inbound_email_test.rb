require 'test_helper'

class InboundEmailTest < ActiveSupport::TestCase
  
  test "factory is valid" do
    assert Factory.build(:inbound_email).valid?
  end
  
  test "gets event from to address" do
    event = Factory(:event, code: "AWESOME")
    ie = Factory(:inbound_email, to: "awesome@usnap.us")
    assert_equal event, ie.event
  end
  
  test "needs a to address" do
    assert Factory.build(:inbound_email, to: nil).invalid?
    assert Factory.build(:inbound_email, to: "").invalid?
  end
  
  test "id needs to be unique" do
    ie = Factory(:inbound_email)
    assert Factory.build(:inbound_email, message_id: ie.message_id).invalid?
  end
    
  
  
end
