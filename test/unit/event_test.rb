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
  
end
