require 'test_helper'

class InboundEmailsControllerTest < ActionController::TestCase
  
  setup do
    @event = Factory(:current_event, code: "AWESOME")
  end
  
  teardown do
    FileUtils.rm_rf "#{Rails.root}/public/uploads/"
  end

  test "can upload photos" do
    
    response = Postmark::Mitt.new(File.new("test/fixtures/files/png_email.json").read)
    Postmark::Mitt.expects(:new).returns(response)
    
    assert_difference ["InboundEmail.count", "Photo.count"] do
      post :create, token: "8eec23eae3465a1078ba541367f4dadd"
      assert_response :success
    end
    photo = Photo.last
    email = InboundEmail.last
    
    assert_equal email, photo.creator
    assert_equal @event, photo.event
    assert_equal @event, email.event
    
    assert_equal "awesome@usnap.us", email.to
    assert_equal "nickmalcolm@gmail.com", email.from
    assert_equal "Nick Malcolm", email.name
    assert_equal "1668649f-f109-4254-a6d6-c6ffb81d8ebb", email.message_id
    assert_equal 1, email.attachment_count
    assert_equal [photo], email.photos
    
    assert_equal [photo], @event.photos
  end
end