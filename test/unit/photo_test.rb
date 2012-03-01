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
  
  test "photo is processing by default" do
    assert Factory(:photo).photo_processing
  end
  
  test "processed photos show in scope" do
    ph = Factory(:photo)
    assert_equal [], Photo.processed
    ph.photo_processing = nil
    ph.save
    assert_equal [ph], Photo.processed
  end
  
  test "after_processing fires Pusher event" do
    photo = Factory(:photo)
    Pusher["test-event-#{photo.event.id}-photocast"].expects(:trigger!).with('new_photo', photo).once
    photo.after_processing
  end
  
end
