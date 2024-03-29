require 'test_helper'

class PhotoTest < ActiveSupport::TestCase
  
  test "factory is valid" do
    assert Factory.build(:photo).valid?
  end
  
  test "photo needs to belong to an event" do
    assert Factory.build(:photo, event: nil).invalid?
    assert Factory.build(:photo, event_id: 100).invalid?
  end
  
  test "photo can have a device creator" do
    assert Factory.build(:photo, creator: Factory(:device)).valid?
  end
  
  test "photo can have a user creator" do
    assert Factory.build(:photo, creator: Factory(:user)).valid?
  end
  
  test "photo can have an inbound email creator" do
    assert Factory.build(:photo, creator: Factory(:inbound_email)).valid?
  end
  
  test "photo needs an creator" do
    assert Factory.build(:photo, creator: nil).invalid?
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
