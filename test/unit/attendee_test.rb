require 'test_helper'

class AttendeeTest < ActiveSupport::TestCase
  
  test "factory is valid" do
    assert Factory.build(:attendee).valid?
  end
  
  test "attendee needs user" do
    assert Factory.build(:attendee, user_id: nil).invalid?
  end
  
  test "attendee needs event" do
    assert Factory.build(:attendee, event_id: nil).invalid?
  end
  
  test "user attends event" do
    event = Factory(:event)
    user = Factory(:user)
    at = Factory(:attendee, event: event, user: user)
    assert user.going_to? event
    assert event.attendees.include?(at)
    assert user.events.include?(event)
    assert !at.is_admin?
  end
  
  test "attendee can be admin" do
    event = Factory(:event)
    user = Factory(:user)
    at = Factory(:attendee, event: event, user: user)
    at.is_admin = true
    at.save!
    assert at.is_admin?
  end
    
  test "can't duplicate an attendee" do
    at = Factory(:attendee)
    assert Factory.build(:attendee, event: at.event, user: at.user).invalid?
  end  
  
end
