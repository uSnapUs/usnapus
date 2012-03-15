require 'test_helper'

class NotifierTest < ActionMailer::TestCase
  
  test "bulk download request" do
    user = Factory :user, email: "nick@usnap.us", name: "Nick Malcolm"
    event = Factory :event, name: "Nick's Party", code: "nick"
    
    email = Notifier.bulk_download_request(user, event).deliver
    assert !ActionMailer::Base.deliveries.empty?
    
    assert_equal ["team@usnap.us"], email.to
    assert_equal "Bulk download request for NICK", email.subject
    
    assert_match /Nick Malcolm/, email.encoded
    assert_match /nick@usnap.us/, email.encoded
    assert_match /Nick's Party/, email.encoded
    assert_match /NICK/, email.encoded
  end
  
end