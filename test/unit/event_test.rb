require 'test_helper'

class EventTest < ActiveSupport::TestCase
  
  test "factory is valid" do
    assert Factory.build(:event).valid?
  end
  
  test "event can have photos" do
    event = Factory :event
    photo = Factory :photo, event: event 
    
    assert_equal 1, event.photos.size
    assert event.photos.include? photo
  end
  
  test "new event has code" do
    assert_match /\A[A-HJKMNP-Z2-9]{7}\Z/, Factory(:event).code
  end
  
  test "new event keeps custom code" do
    nick = Factory(:event, code: "nick")
    assert_equal "NICK", nick.code
    nick.save!
    assert_equal "NICK", nick.code
  end
  
  test "new event code is parameterized" do
    assert_equal "NICK-S-1-EVENT", Factory(:event, code: "Nick's #1 Event").code
  end
  
  test "new event has an s3 token" do
    assert_equal 32, Factory(:event).s3_token.length
  end
  
  test "event code is unique" do
    new_code = Factory(:event).code
    e = Factory(:event)
    e.code = new_code
    assert e.invalid?
  end
  
end
